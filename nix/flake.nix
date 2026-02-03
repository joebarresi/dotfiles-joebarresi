{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }: 
    let
      lib = nixpkgs.lib;
    in {
    darwinConfigurations."Work-Mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jbarresi = { pkgs, lib, ... }: {
            home.username = "jbarresi";
            home.homeDirectory = lib.mkForce "/Users/jbarresi";
            home.stateVersion = "24.05";
            home.packages = [];
          };
        }
      ];
    };
  };
}
