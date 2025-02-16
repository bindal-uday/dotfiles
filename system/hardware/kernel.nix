{ config, pkgs, ... }:

{
  # Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0"
    "video4linux"
  ];
}
