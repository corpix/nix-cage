{ nixpkgs, system, self }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  inherit (pkgs) lib;

  testing = import "${nixpkgs}/nixos/lib/testing-python.nix" {
    inherit system pkgs;
  };

  nix-cage = self.packages.${system}.default;

  # Recursively collect outPaths of all transitive flake inputs so that
  # `nix eval` on the staged source can resolve every locked entry without
  # network access from inside the VM.
  collectInputs = flake:
    lib.optional (flake ? outPath) flake.outPath
    ++ lib.optionals (flake ? inputs)
      (lib.concatMap collectInputs (lib.attrValues flake.inputs));
  allInputs = lib.unique (collectInputs self);

  testPkgs = self.inputs.nixpkgs.legacyPackages.${system};
  testShellDevelop = testPkgs.mkShell { NIX_CAGE_LAUNCHER_PROBE = "develop"; };
  testShellShell = testPkgs.mkShell { NIX_CAGE_LAUNCHER_PROBE = "shell"; };

  machineModule = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nix-cage
      bashInteractive
      coreutils
      jq
      nix
      bubblewrap
      python3
      inetutils
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.registry = {
      nixpkgs.flake = self.inputs.nixpkgs;
      flake-utils.flake = self.inputs.flake-utils;
    };

    environment.variables.NIX_REMOTE = "daemon";

    virtualisation.memorySize = 2048;
    virtualisation.diskSize = 4096;

    systemd.tmpfiles.rules = [
      "d /nix/var/log/nix 0755 root root - -"
    ];

    system.extraDependencies = allInputs ++ [
      testShellDevelop
      testShellShell
    ];
  };

  stage = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # Stage source where the bash tests expect it, then point the entry
    # script and `result` symlink at the wrapped package output so tests
    # exercise the real binary regardless of which path they invoke.
    machine.succeed("cp -r ${self} /tmp/src")
    machine.succeed("chmod -R u+w /tmp/src")
    machine.succeed("ln -sfn ${nix-cage}/bin/nix-cage /tmp/src/nix-cage")
    machine.succeed("ln -sfn ${nix-cage} /tmp/src/result")
  '';

  runBash = file: ''
    print("== ${file}")
    output = machine.succeed("cd /tmp && bash /tmp/src/test/${file} 2>&1")
    print(output)
  '';

  mkTest = { name, files }: testing.simpleTest {
    inherit name;
    nodes.machine = machineModule;
    testScript = stage + lib.concatStringsSep "\n" (map runBash files);
  };

  testFiles = [
    "010-basic.bash"
    "020-flake-config.bash"
    "030-sandbox.bash"
    "040-launchers.bash"
    "050-isolation.bash"
    "060-mount-suffix.bash"
    "070-merge.bash"
    "080-expansion.bash"
    "090-create.bash"
  ];
in {
  basic        = mkTest { name = "nix-cage-basic";        files = [ "010-basic.bash" ]; };
  flake-config = mkTest { name = "nix-cage-flake-config"; files = [ "020-flake-config.bash" ]; };
  sandbox      = mkTest { name = "nix-cage-sandbox";      files = [ "030-sandbox.bash" ]; };
  launchers    = mkTest { name = "nix-cage-launchers";    files = [ "040-launchers.bash" ]; };
  isolation    = mkTest { name = "nix-cage-isolation";    files = [ "050-isolation.bash" ]; };
  mount-suffix = mkTest { name = "nix-cage-mount-suffix"; files = [ "060-mount-suffix.bash" ]; };
  merge        = mkTest { name = "nix-cage-merge";        files = [ "070-merge.bash" ]; };
  expansion    = mkTest { name = "nix-cage-expansion";    files = [ "080-expansion.bash" ]; };
  create       = mkTest { name = "nix-cage-create";       files = [ "090-create.bash" ]; };

  default = mkTest { name = "nix-cage"; files = testFiles; };
}
