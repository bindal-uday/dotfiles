{ config, lib, pkgs, ... }:

{
  # Enable display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          let
            session = config.services.displayManager.sessionData.desktops;
          in
            "${pkgs.greetd.tuigreet}/bin/tuigreet -t -s ${session}/share/xsessions:${session}/share/wayland-sessions";
      };
    };
  };

  # systemPackages
  environment.systemPackages = with pkgs; [
    greetd.greetd                      # login manager daemon
    greetd.tuigreet                    # greeter for greetd 
  ];
}
