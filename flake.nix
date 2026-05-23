{
  description = "Sandboxed environments with bwrap and nix-shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixCageModule = import ./nix/module.nix {
        lib = nixpkgs.lib;
      };

      mkNixCageConfiguration =
        { modules ? [ ] }:
        let
          evaluated = nixpkgs.lib.evalModules {
            modules = [
              nixCageModule
            ] ++ modules;
          };
        in
        evaluated
        // {
          config = evaluated.config.renderedConfig;
          moduleConfig = builtins.removeAttrs evaluated.config [ "renderedConfig" ];
        };
    in
    {
      lib = {
        inherit nixCageModule mkNixCageConfiguration;
      };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          runtimePath = pkgs.lib.makeBinPath (with pkgs; [
            bubblewrap
            nix
          ]);
        in
        {
          default = pkgs.stdenv.mkDerivation rec {
            pname = "nix-cage";
            version = "0.1.0";

            src = self;

            nativeBuildInputs = with pkgs; [
              makeWrapper
              python3
            ];

            buildInputs = with pkgs; [
              bubblewrap
              nix
            ];

            buildPhase = ''
              runHook preBuild
              patchShebangs nix-cage
              runHook postBuild
            '';

            checkPhase = ''
              runHook preCheck
              python -m py_compile nix-cage
              runHook postCheck
            '';

            doCheck = true;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin
              cp nix-cage $out/bin/${pname}
              chmod +x $out/bin/${pname}

              wrapProgram $out/bin/${pname} --prefix PATH : ${runtimePath}

              runHook postInstall
            '';

            meta = with pkgs.lib; {
              homepage = "https://github.com/corpix/nix-cage";
              description = "Sandboxed environments with nix-shell";
              longDescription = ''
                Sandboxed environments with bwrap and nix-shell.
              '';
              license = licenses.unlicense;
              platforms = platforms.linux;
              mainProgram = "nix-cage";
            };
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bashInteractive
              bubblewrap
              gnumake
              jq
              nix
              python3
            ];
          };
        }
      );
    };
}
