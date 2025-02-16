{ inputs, lib, config, pkgs, pkgs-stable, ... }:

let
    hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in
{

  # Enable hyprland and related stuff
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Set the flake pkgs
    package = hyprlandPkg;
    portalPackage = portalPkg;
  };

  # security
  services.gnome.gnome-keyring.enable = true;
  security = {
    pam.services.login.enableGnomeKeyring = true;
    polkit.enable = true;
  };

  # environment vars
  environment.sessionVariables = {
    # Hint Electon apps to use wayland
    NIXOS_OZONE_WL = "1";
    # mouse/touchpad cursor
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # QT theme
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
  
  # Some system packages
  environment.systemPackages = (with pkgs; [

    # Window Manager --------------------------------------------------- #
    avizo                              # brightness & volume daemon
    brightnessctl                      # screen brightness control
    cliphist                           # clipboard manager
    dunst                              # notification daemon
    grim                               # grab image tool
    grimblast                          # screenshot tool
    hyprcursor                         # cursor
    hypridle                           # idle utility
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

    # Dependencies ----------------------------------------------------- #
    gnome-keyring                      # store pass, keys, etc
    imagemagick                        # for image processing
    jq                                 # for json processing
    libnotify                          # for notifications
    parallel                           # for parallel processing
    wlr-randr                          # randr for wlroots compositors

    # Theming ---------------------------------------------------------- #
    libadwaita                         # adwaita
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
