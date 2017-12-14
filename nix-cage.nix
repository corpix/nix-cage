with import <nixpkgs> {};
python36Packages.buildPythonApplication {

  name = "nix-cage";

  buildInputs = [ bubblewrap ];

  src = fetchFromGitHub {
    owner  = "corpix";
    repo   = "nix-cage";
    rev    = "b56a3d4ba9ee589fbad304df1ec901e307fc0e3b";
    sha256 = "1vhkshg84y2vxgfwc2mdb13zx39nyf8j6aq2hkpglmxsb9x76l4d";
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
