let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/nixos/nixpkgs/archive/7eaaf728e4f1e37637d20204e7102db7ccf3b10c.tar.gz";
    sha256 = "0k02qw9ivb8y5whp4xysnwyp3rw1lqrb8khaazf43zpksmrncw2j";
  };
in with (import nixpkgs {}); stdenv.mkDerivation {
  name = "nix-shell";
  buildInputs = [
    gnumake
    bashInteractive
    python3
    jq
  ];
  shellHook = ''
    export NIX_PATH=nixpkgs=${nixpkgs}
  '';
}
