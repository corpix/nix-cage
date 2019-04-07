with import <nixpkgs> {};
stdenv.mkDerivation rec {

  name = "nix-cage";

  buildInputs = [ python36 bubblewrap nix ];
  nativeBuildInputs = [ makeWrapper ];

  src = ./.;

  buildPhase = ''
    patchShebangs .
  '';

  installPhase = ''
    source $stdenv/setup
    set -e

    mkdir -p $out/bin
    cp       $src/${name}    $out/bin
    chmod +x $out/bin/${name}

    wrapProgram $out/bin/${name} --prefix PATH : ${stdenv.lib.makeBinPath [
      bubblewrap
      nix
    ]}
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
