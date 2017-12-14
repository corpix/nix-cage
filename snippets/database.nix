with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-database-shell";
  buildInputs = [
    influxdb
  ];
}
