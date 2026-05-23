{ lib }:
{ config, ... }:

let
  inherit (lib)
    literalExpression
    mkOption
    types
    ;

  mountType = types.oneOf [
    types.str
    (types.submodule {
      options = {
        source = mkOption {
          type = types.str;
          description = "Host path to mount.";
        };

        target = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Sandbox target path. Defaults to source.";
        };

        create = mkOption {
          type = types.bool;
          default = false;
          description = "Create the source directory before starting the sandbox.";
        };
      };
    })
  ];

  renderMount =
    mount:
    if builtins.isString mount then
      mount
    else
      let
        target = if mount.target == null then mount.source else mount.target;
      in
      [
        mount.source
        target
      ]
      ++ lib.optional mount.create "d";

  renderMounts = mounts: builtins.map renderMount mounts;
in
{
  options = {
    mode = mkOption {
      type = types.enum [
        "expand"
        "replace"
      ];
      default = "expand";
      description = "Merge mode used when overlaying nix-cage configuration.";
    };

    mounts = mkOption {
      default = { };
      description = "Sandbox mount declarations.";
      type = types.submodule {
        options = {
          rw = mkOption {
            type = types.listOf mountType;
            default = [ ];
            example = literalExpression ''[ "~/.emacs.d" { source = "./.config"; target = "~/.config"; create = true; } ]'';
            description = "Read/write mounts.";
          };

          ro = mkOption {
            type = types.listOf mountType;
            default = [ ];
            description = "Read-only mounts.";
          };

          dev = mkOption {
            type = types.listOf mountType;
            default = [ ];
            description = "Device mounts.";
          };

          tmpfs = mkOption {
            type = types.listOf mountType;
            default = [ ];
            description = "tmpfs mounts.";
          };
        };
      };
    };

    launcher = mkOption {
      type = types.nullOr (types.enum [
        "nix-develop"
        "nix-shell"
        "direct"
      ]);
      default = null;
      description = "Command launcher to force. Null keeps nix-cage automatic launcher detection.";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables set inside the sandbox.";
    };

    arguments = mkOption {
      default = { };
      description = "Command-line arguments passed to sandbox helpers.";
      type = types.submodule {
        options = {
          bwrap = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Additional bwrap arguments.";
          };

          nixShell = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Additional nix-shell arguments.";
          };

          nixDevelop = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Additional nix develop arguments.";
          };
        };
      };
    };

    command = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run inside the sandbox.";
    };

    renderedConfig = mkOption {
      type = types.attrs;
      readOnly = true;
      internal = true;
      description = "Python-compatible nix-cage JSON configuration.";
    };
  };

  config.renderedConfig =
    let
      cfg = config;
    in
    {
      inherit (cfg) mode launcher;
      mounts = builtins.mapAttrs (_: renderMounts) cfg.mounts;
      inherit (cfg) environment;
      arguments =
        {
          inherit (cfg.arguments) bwrap;
          "nix-shell" = cfg.arguments.nixShell;
          "nix-develop" = cfg.arguments.nixDevelop;
        }
        // lib.optionalAttrs (cfg.command != null) {
          inherit (cfg) command;
        };
    };
}
