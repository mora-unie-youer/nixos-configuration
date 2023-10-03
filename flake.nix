{
  description = "nixos-configuration - Mora Unie Youer's NixOS configuration";

  inputs = {
    # Nix/NixOS related repositories
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # NixOS user repository
    nurpkgs.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Useful Nix Flake libraries
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    # Firefox Nightly
    firefox = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helix editor
    helix = {
      url = "github:helix-editor/helix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Latest Hyprland changes and XDG portal
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland utility to handle workspaces on different monitors
    hyprsome = {
      url = "github:/sopa0/hyprsome";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Secure Boot alternative to GRUB bootloader in NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,

    nixpkgs,
    nixpkgs-stable,
    nurpkgs,
    home-manager,

    flake-compat,
    flake-utils,

    firefox,
    helix,
    hyprland,
    hyprsome,
    lanzaboote,

    ...
  } @ inputs: let
    system = "x86_64-linux";

    mkSystem = additionalModules: nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        # "Generic" system module
        (import ./modules/system/common { inherit lanzaboote hyprland; })

        # Setting some state version
        { system.stateVersion = "23.11"; }
      ] ++ additionalModules;
    };

    mkUser = additionalModules: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};

      extraSpecialArgs = { inherit firefox helix hyprsome nurpkgs; };
      modules = [
        # "Generic" user module
        ./modules/user/common
      ] ++ additionalModules;
    };
  in {
    # My NixOS configurations
    nixosConfigurations = {
      # NixOS system for my Thinkpad P53s laptop
      thinkpad-p53s = mkSystem [ ./modules/system/thinkpad-p53s ];
    };

    # My user configurations
    homeConfigurations = {
      "mora@thinkpad-p53s" = mkUser [
        hyprland.homeManagerModules.default
        ./modules/user/mora
      ];
    };
  };
}
