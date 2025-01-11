{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/7d27fd2b04ede95f27fdce6b8902745777ad4844";
    home-manager.url = "github:nix-community/home-manager";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:nix-community/nixGL";

    # styling
    catppuccin-cursors.url = "github:catppuccin/cursors";
    catppuccin.url = "github:catppuccin/nix";

    # secrets
    # agenix.url = "github:ryantm/agenix";

    # zen browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;

      src = ./.;

      snowfall = {
        meta = {
          name = "kamilov";
          title = "My NixOS flake";
        };

        metadata = "kix";
        namespace = "kix";
      };
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;

        permittedInsecurePackages = [];
      };

      overlays = with inputs; [
        nixgl.overlay
        nur.overlays.default
      ];

      lib.scan = inputs.snowfall-lib.fs.get-default-nix-files-recursive;

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote
      ];
    };
}
