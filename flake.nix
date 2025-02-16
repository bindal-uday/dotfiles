{
  description = "Levi's nixos configuration";

  outputs = {
              self,
              nixpkgs,
              nixpkgs-stable,
              chaotic,
              home-manager,
              hyprland,
              programs-db,
              cachix,
              ...
            }@inputs:
  
  let

    # ---- SYSTEM Configuration ---- #
    systemConfig = {
      system = "x86_64-linux";
      hostname = "nixos";
      timezone = "Asia/Kolkata";
      locale = "en_US.UTF-8";
      bootMode = "uefi"; # uefi or bios
      bootMountPath = "/boot";
      grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
    };

    # ----- USER Configuration ----- #
    userConfig = {
      # Shell
      shell = "fish";

      # users
      username = "error";
      name = "ERROR";

      username2 = "levi";
      name2 = "Levi";

      dotfilesDir = "~/dotfiles";
      dotfilesDirName = "dotfiles";

      themeConfig = {
        cursorPkg = pkgs.bibata-cursors;
        cursor = "Bibata-Modern-Ice";

        themePkg = pkgs.adw-gtk3;
        theme = "adw-gtk3-dark";

        iconPkg = pkgs.tela-circle-icon-theme;
        icon = "Tela-circle";
      };

    };

    system = systemConfig.system;
    lib = nixpkgs.lib;

    # from nixpkgs channel
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    # from nixpkgs-stable channel
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

  in
  {

    nixosConfigurations =

    let

      systemModules = [
        # define nix modules
        ./NixOS/system/configuration.nix
        chaotic.nixosModules.default
        {
          nixpkgs.overlays = [
            # example.overlay
            # inputs.example-overlay.overlay
          ];
        }
      ];

      specialArgs = {
        inherit pkgs-stable;
        inherit systemConfig;
        inherit userConfig;
        inherit inputs;
      };

    in
    {
      ${systemConfig.hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = specialArgs;
        modules = systemModules ++ [
          ./NixOS/system/hardware-configuration.nix
        ];
      };
    };

    homeConfigurations =
    let
      userModules = [
        # user nix modules
        ./NixOS/user/home.nix
      ];
      extraSpecialArgs = {
        inherit pkgs-stable;
        inherit systemConfig;
        inherit userConfig;
        inherit inputs;
      };
    in
    {
      ${userConfig.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = extraSpecialArgs;
        modules = userModules;
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    cachix.url = "github:cachix/cachix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # home-manager follows nixpkgs channel
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    programs-db = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

}
