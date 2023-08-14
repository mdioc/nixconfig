{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs @ { nixpkgs, home-manager, hyprland, ...}:
    let  
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = { 
      	ni15a = lib.nixosSystem { 
          inherit system;
          modules = [
   	    ./laptop-conf.nix
            hyprland.nixosModules.default
            {
              programs.hyprland = {
                enable = true;
              };
            }    
	    home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.mdo = import ./home.nix;
            }
          ];
        };
        ni12a = lib.nixosSystem {
          inherit system;
          modules = [
            ./desktop-conf.nix
            hyprland.nixosModules.default
            {
              programs.hyprland.enable = true;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
  	      home-manager.useUserPackages = true;
  	      home-manager.users.mdo = import ./home.nix;
            }
          ];
        };
      };
    };  
}
