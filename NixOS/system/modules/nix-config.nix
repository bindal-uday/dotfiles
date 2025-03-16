{ config, lib, inputs, systemConfig, ... }:

let
  system = systemConfig.system;
  programs-db = inputs.programs-db.packages.${system}.programs-sqlite;
in
{

  # programs db
  programs.command-not-found.dbPath = programs-db;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # nix-settings
  nix = {
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids
      max-substitution-jobs = 64
      http-connections = 64
      auto-allocate-uids = true
      auto-optimise-store = true
    '';
  
    settings = {
      trusted-users = [ "root" "levi" "@wheel" ];
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    # auto scheduled GC running
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}
