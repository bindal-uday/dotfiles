{
  inputs,
  config,
  lib,
  pkgs,
  pkgs-stable,
  systemConfig,
  ...
}:

let
  system = systemConfig.system;
  py = pkgs.python3Packages;
  zen-browser = inputs.zen-browser.packages."${system}".default;
in
{

  # user pkgs
  programs = {
    adb.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  ## TWO VERSIONS OF SAME PACKAGE (BINARY) DOESN'T WORK!!
  environment.systemPackages = (with pkgs; [

    # CLI Tools / Dependencies ----------------------------------------- #
    vim
    tree
    wget axel
    htop btop usbtop
    nix-index nix-prefetch-git
    cachix
    zip unzip unrar
    fzf
    android-tools

    # Shell ------------------------------------------------------------ #
    git gh glab                        # version control
    eza lsd                            # file lister
    starship                           # customizable shell prompt
    fastfetch                          # system information fetch tool
    imagemagick                        # for custom fetch logo
    krabby                             # display pokemon sprites
    cava                               # cli audio visualizer
    yt-dlp                             # cli utility for yt
    openssh                            # SSH protocol
    tmate                              # instant terminal sharing
    tmux                               # terminal multiplexer

    # System stuff ----------------------------------------------------- #
    brightnessctl                      # screen brightness control
    gparted                            # partition manager
    usbutils                           # tools for usb
    pciutils                           # tools for pci

    # GPU & power stuff ------------------------------------------------ #
    amdvlk                             # AMD OSS Driver For Vulkan
    thermald                           # thermal daemon
    tlp                                # advanced power management

    # Applications ----------------------------------------------------- #
    onlyoffice-bin                     # office
    wl-screenrec                       # screen rec
    alacritty foot                     # terminal
    ranger                             # TUI file manager
    mpv                                # media player
    imv                                # image viewer
    firefox                            # browser
    zen-browser                        # firefox fork
    librewolf                          # browser2
    motrix                             # Download manager
    stremio                            # binge
    ani-cli                            # anime cli
    vscodium                           # ide text editor
    neovim                             # terminal text editor
    neovide                            # GUI for neovim
    lazygit                            # TUI git tool
    telegram-desktop                   # telegram

    # dependencies ----------------------------------------------------- #
    ripgrep                            # search with regex pattern
    nodePackages.nodejs                # framework for JS engine
    nodePackages.npm                   # npm
    python3                            # python3
    (py.pip)                           # py pkgs
    (py.pandas)                        # pandas
    (py.pillow)                        # PIL fork
    (py.openpyxl)                      # excel lib
    stylua lua-language-server         # lua formatter & lsp
    gcc gnumake                        # GNU compiler & make                            # make system

  ]) ++ (with pkgs-stable; [

    # pkgs from stable branch

  ]);

}
