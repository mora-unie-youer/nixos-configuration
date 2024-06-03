{
  inputs = {
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,

    nixpkgs,
    home-manager,

    lanzaboote,
    musnix,

    ...
  } @ inputs: let
    system = "x86_64-linux";

    mkSystem = additionalModules: nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        lanzaboote.nixosModules.lanzaboote
        musnix.nixosModules.default

        ./system/common
        { system.stateVersion = "24.05"; }
      ] ++ additionalModules;
    };

    mkUser = additionalModules: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};

      extraSpecialArgs = {};
      modules = [
        ./user/common
      ] ++ additionalModules;
    };
  in {
    nixosConfigurations = {
      "sapphire" = mkSystem [
        ./system/sapphire

        ({ pkgs, ...}: {
          users.users.mora = {
            isNormalUser = true;
            extraGroups = [ "adbusers" "audio" "docker" "input" "tty" "video" "wheel" ];
            shell = pkgs.fish;
          };
        })
      ];
    };

    homeConfigurations = {
      "mora" = mkUser [ ./users/mora ];
    };
  };
}
