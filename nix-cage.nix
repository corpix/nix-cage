with import <nixpkgs> {};
python36Packages.buildPythonApplication {

  name = "nix-cage";

  buildInputs = [ bubblewrap ];

  src = fetchFromGitHub {
    owner  = "corpix";
    repo   = "nix-cage";
    rev    = "a731efaabcb67a4e9db933f452b7681229d64baa";
    sha256 = "1fn4wx6pjmy899qjg7nq0sm66ky3ll69mdica0h7577sgsldm9cm";
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
