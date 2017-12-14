with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-c-shell";
  buildInputs = [
    autoconf
    automake
    clang
    gcc
    lld
    llvm
  ];
}
