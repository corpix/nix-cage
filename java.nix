with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-java-shell";
  buildInputs = [
    (lowPrio jre)
    jdk
    ant
    gradle
    groovy
  ];
}
