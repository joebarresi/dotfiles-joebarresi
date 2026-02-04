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
    mkDarwinConfig = { username, hostConfig, homeProfile }: nix-darwin.lib.darwinSystem {
      modules = [
        hostConfig
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home.nix { inherit username homeProfile; };
        }
      ];
    };
  in {
    darwinConfigurations."80a9972b1e3d" = mkDarwinConfig {
      username = "jbarresi";
      hostConfig = ./hosts/amazon.nix;
      homeProfile = ./profiles/home/amazon.nix;
    };

    darwinConfigurations."Josephs-MacBook-Air" = mkDarwinConfig {
      username = "josephbarresi";
      hostConfig = ./hosts/personal.nix;
      homeProfile = ./profiles/home/personal.nix;
    };
  };
}
