{
  lib,
  stdenv,
  makeWrapper,
  python3,
  bubblewrap,
  nix,
  src,
}:

let
  runtimePath = lib.makeBinPath [
    bubblewrap
    nix
  ];
in
stdenv.mkDerivation rec {
  pname = "nix-cage";
  version = "0.1.0";

  inherit src;

  nativeBuildInputs = [
    makeWrapper
    python3
  ];

  buildInputs = [
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

  meta = with lib; {
    homepage = "https://github.com/corpix/nix-cage";
    description = "Sandboxed environments with nix-shell";
    longDescription = ''
      Sandboxed environments with bwrap and nix-shell.
    '';
    license = licenses.unlicense;
    platforms = platforms.linux;
    mainProgram = "nix-cage";
  };
}
