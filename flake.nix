{
  description = "A simple object-based memory allocator with epoch-based garbage collection";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in
      {
        packages.default = pkgs.callPackage ./default.nix {};
      }
    );
}
