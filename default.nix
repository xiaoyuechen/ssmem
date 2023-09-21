{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "ssmem";
  version = "68f0dad";
  src = ./.;
  installPhase = ''
    mkdir -p $out/include
    cp -r $src/include/*.h $out/include
    mkdir -p $out/lib
    cp libssmem.a $out/lib
  '';
}
