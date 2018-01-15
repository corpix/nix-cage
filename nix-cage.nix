with import <nixpkgs> {};
python36Packages.buildPythonApplication {

  name = "nix-cage";

  buildInputs = [ bubblewrap ];

  src = fetchFromGitHub {
    owner  = "corpix";
    repo   = "nix-cage";
    rev    = "16f644e88ce6d408a7d8a9bd6241048db464f0e2";
    sha256 = "046r69zxf7dybk22rysh9z2kqbixb6i6vxrr8yjhnlybgmvnxs9a";
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
