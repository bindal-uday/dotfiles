{ config, pkgs, userConfig, ... }:

{

  home.file = {
    
    # Alacritty config
    ".config/alacritty".source = ../../config/alacritty;

    # foot config
    ".config/foot".source = ../../config/foot;

    # wezterm config
    ".config/wezterm".source = ../../config/wezterm;

    # Avizo config
    ".config/avizo".source = ../../config/avizo;

    # Dunst notification daemon
    ".config/dunst".source = ../../config/dunst;

    # fastfetch config
    ".config/fastfetch".source = ../../config/fastfetch;

    # hypr config
    ".config/hypr".source = ../../config/hypr;

    # rofi config
    ".config/rofi".source = ../../config/rofi;

    # waybar config
    ".config/waybar".source = ../../config/waybar;

    # wlogout config
    ".config/wlogout".source = ../../config/wlogout;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

}

