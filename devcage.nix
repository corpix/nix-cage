{ stdenv, pkgs, fetchFromGitHub }:
with pkgs;
python36Packages.buildPythonApplication {

  name = "devcage";

  src = fetchFromGitHub {
    owner  = "corpix";
    repo   = "devcage";
    rev    = "11541a82fe291f5d59e7fac5116c36991208d31b";
    sha256 = "072xhpra24hmy4l8jpgsfyrk4ayc9w85rh15pxy1d04sw3p67x8x";
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    set -e

    mkdir -p $out/{nix,bin}
    cp       $src/*.nix       $out/nix
    cp       $src/devcage     $out/bin
    chmod +x $out/bin/devcage
  '';

  meta = {
    homepage = https://github.com/corpix/devcage;
    description = "Sandboxed development environments";

    longDescription = ''
      Sandboxed development environments with bwrap, nix-shell and emacs
    '';

    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
