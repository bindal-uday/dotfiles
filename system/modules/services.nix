{ config, lib, pkgs, ... }:

{

  # List services that you want to enable:

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  systemd.services.tpm-rm0 = {
    enable = false;
    wantedBy = [ ];
    after = [ ];
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

}
