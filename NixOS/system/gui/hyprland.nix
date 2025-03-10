{ inputs, lib, config, pkgs, pkgs-stable, ... }:

{

  # Enable hyprland and related stuff
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Set the flake pkgs
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # security
  services.gnome.gnome-keyring.enable = true;
  security = {
    pam.services.login.enableGnomeKeyring = true;
    polkit.enable = true;
    # polkit.package = pkgs.polkit_gnome;
  };

  # cross desktop grouping (sandbox apps)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # environment vars
  environment.sessionVariables = {
    # Hint Electon apps to use wayland
    NIXOS_OZONE_WL = "1";
    # mouse/touchpad cursor
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # QT theme
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "gnome";
  
  # Some system packages
  
  environment.systemPackages = (with pkgs; [

    # Window Manager --------------------------------------------------- #
    avizo                              # brightness & volume daemon
    brightnessctl                      # screen brightness control
    cliphist                           # clipboard manager
    dunst                              # notification daemon
    grim                               # grab image tool
    grimblast                          # screenshot tool
    gvfs                               # virtual fs 
    hyprcursor                         # cursor
    hypridle                           # idle utility
    hyprland                           # wlroots-based wayland compositor
    hyprlock                           # lock utility
    hyprpaper                          # wallpaper daemon
    hyprpicker                         # color picker
    nemo-with-extensions               # file manager
    playerctl                          # media control
    rofi-wayland                       # application launcher
    slurp                              # region select for screenshot/screenshare
    swappy                             # screenshot editor
    swaylock-effects                   # lock screen
    swww                               # wallpaper
    waybar                             # system bar
    wl-clip-persist                    # clipboard-persist
    wl-clipboard                       # clipboard 
    wlogout                            # logout menu
    xwayland                           # interface X11 apps with Wayland protocol

    # Dependencies ----------------------------------------------------- #
    gnome-keyring                      # store pass, keys, etc
    hyprpolkitagent                    # polkit agent in qt/qml
    imagemagick                        # for image processing
    jq                                 # for json processing
    libnotify                          # for notifications
    parallel                           # for parallel processing
    polkit_gnome                       # authentication agent
    wlr-randr                          # randr for wlroots compositors
    xdg-desktop-portal-gtk             # xdg desktop portal for gtk
    xdg-desktop-portal-hyprland        # xdg desktop portal for hyprland

    # Theming ---------------------------------------------------------- #
    adw-gtk3                           # adwaita gtk3 theme
    adwaita-icon-theme                 # icon theme
    kdePackages.qt6ct                  # qt6 configuration tool
    kdePackages.qtstyleplugin-kvantum  # svg based qt6 theme engine
    kdePackages.qtwayland              # wayland support in qt6
    libsForQt5.qt5.qtwayland           # wayland support in qt5
    libsForQt5.qt5ct                   # qt5 configuration tool
    libsForQt5.qtstyleplugin-kvantum   # svg based qt5 theme engine
    nwg-look                           # gtk configuration tool

  ]) ++ (with pkgs-stable; [

    # pkgs from stable branch

  ]);

}
