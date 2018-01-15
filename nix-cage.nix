with import <nixpkgs> {};
python36Packages.buildPythonApplication {

  name = "nix-cage";

  buildInputs = [ bubblewrap ];

  src = fetchFromGitHub {
    owner  = "corpix";
    repo   = "nix-cage";
    rev    = "dc9f911d3bff2a6ec0c5049bdae72db053f4207c";
    sha256 = "1vsfbp7qkfq28zwj539gayh3cn3gzfgzvkg60jdm0zj5rdanb4is";
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    set -e

    mkdir -p $out/bin
    cp       $src/nix-cage    $out/bin
    chmod +x $out/bin/nix-cage
  '';

  meta = {
    homepage = https://github.com/corpix/nix-cage;
    description = "Sandboxed environments with nix-shell";

    longDescription = ''
      Sandboxed environments with bwrap and nix-shell
    '';

    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
