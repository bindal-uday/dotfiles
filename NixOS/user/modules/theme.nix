{ config, pkgs, userConfig, ... }:

{

  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-frappe-blue-standard";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  # QT
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "kvantum";
  };

  home.packages = with pkgs; [
    # Theming
    nwg-look                           # gtk configuration tool
    libsForQt5.qt5ct                   # qt5 configuration tool
    kdePackages.qt6ct                  # qt6 configuration tool
    libsForQt5.qtstyleplugin-kvantum   # svg based qt5 theme engine
    kdePackages.qtstyleplugin-kvantum  # svg based qt6 theme engine
    libsForQt5.qt5.qtwayland           # wayland support in qt5
    kdePackages.qtwayland              # wayland support in qt6
    adw-gtk3                           # adwaita gtk3 theme
    catppuccin-kvantum                 # catppuccin kvantum theme
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "catppuccin-frappe-blue-standard";
    ICON_THEME = "Papirus-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 24;
  };

}
