{ pkgs, ... }:

{
  # Enable graphic hw drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # for wine like pkgs
    extraPackages = with pkgs; [
      rocmPackages.clr
      libvdpau-va-gl
      libva
      libva-vdpau-driver
      vaapiVdpau
      mesa
    ];
    # for 32 Bit applications
    extraPackages32 = with pkgs; [
      vaapiVdpau
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
