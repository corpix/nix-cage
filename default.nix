with import <nixpkgs> {};
stdenv.mkDerivation rec {

  name = "nix-cage";

  buildInputs = [ python36 bubblewrap nix ];

  src = fetchFromGitHub {
    owner  = "corpix";
    repo   = name;
    rev    = "a731efaabcb67a4e9db933f452b7681229d64baa";
    sha256 = "1fn4wx6pjmy899qjg7nq0sm66ky3ll69mdica0h7577sgsldm9cm";
  };

  buildPhase = ''
    patchShebangs .
  '';

  installPhase = ''
    source $stdenv/setup
    set -e

    mkdir -p $out/bin
    cp       $src/${name}    $out/bin
    chmod +x $out/bin/${name}
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
