{
  description = "Freshly built Olex2 launcher for Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    src = {
      flake = false;
      url = "github:pcxod/olex2/1.5";
    };
  };

  outputs = { self, nixpkgs, src }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    python = pkgs.python38;
  in {
    packages.${system} = {
      olex2-dropin = pkgs.callPackage ./dropin.nix {
        inherit src python;
        version = "1.5";
        scons = pkgs.scons.override { inherit python; };
        wxGTK = pkgs.wxGTK32;
      };
      olex2-launcher = pkgs.callPackage ./fhs.nix {
        inherit (self.packages.${system}) olex2-dropin;
      };
      olex2-launcher-x11 = self.packages.${system}.olex2-launcher.override {
        forceX11 = true;
      };
    };
  };
}
