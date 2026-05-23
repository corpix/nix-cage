{
  description = "Sandboxed environments with bwrap and nix-shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    let
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

      mkSandboxedDevShell =
        {
          system,
          modules ? [ ],
          pkgs ? nixpkgs.legacyPackages.${system},
          packages ? [ ],
          shellHook ? "",
        }:
        let
          configuration = mkNixCageConfiguration {
            modules = modules ++ [
              {
                launcher = nixpkgs.lib.mkForce "direct";
              }
            ];
          };
          configFile = pkgs.writeText "nix-cage.json" (builtins.toJSON configuration.config);
        in
        pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
          ] ++ packages;

          shellHook = ''
            if [ -z "''${NIX_CAGE_ACTIVE:-}" ]; then
              export NIX_CAGE_ACTIVE=1
              exec ${self.packages.${system}.default}/bin/nix-cage --config ${configFile} --launcher direct
            fi

            ${shellHook}
          '';
        };
    in
    {
      lib = {
        inherit nixCageModule mkNixCageConfiguration mkSandboxedDevShell;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nix-cage = pkgs.callPackage ./nix/package.nix {
          src = self;
        };
      in
      {
        packages = {
          default = nix-cage;
        };

        devShells = {
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
        };
      }
    );
}
