{ config, pkgs, ... }:

{
  # Plasma DE
  services = {
    xserver.desktopManager.gnome.enable = true;
  };

  # kde programs
  programs = {
    kdeconnect.enable = true;
  };

  # systemPackages
  environment.systemPackages = with pkgs; [
    # list of pkgs
    kdePackages.kdeconnect-kde
  ];

}
