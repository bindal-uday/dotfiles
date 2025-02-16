{ config, lib, pkgs, ... }:

{
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pa-notify                          # vol notify
    easyeffects                        # audio effects
    pamixer                            # pulseaudio cli mixer
    pwvucontrol                        # Pipewire volume control
  ];
}
