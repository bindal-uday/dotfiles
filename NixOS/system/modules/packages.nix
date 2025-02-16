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
  zen-browser = inputs.zen-browser.packages."${system}".default;
in
{

  # programs
  programs = {
    adb.enable = true;
  };

  # dynamic linked executables
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  ## TWO VERSIONS OF SAME PACKAGE (BINARY) DOESN'T WORK!!
  environment.systemPackages = (with pkgs; [

    # CLI Tools / Dependencies ----------------------------------------- #
    vim 
    tree
    wget
    axel
    htop
    btop
    usbtop
    nh
    nix-index
    nix-prefetch-git
    cachix
    zip
    unzip
    unrar 
    fzf
    android-tools
    adbtuifm

    # Shell ------------------------------------------------------------ #
    git                                # version control
    gh                                 # github cli
    glab                               # gitlab cli
    eza                                # file lister for zsh
    lsd                                # file lister for fish
    starship                           # customizable shell prompt
    fastfetch                          # system information fetch tool
    imagemagick                        # for custom fetch logo
    cava                               # cli audio visualizer
    yt-dlp                             # cli utility for yt
    openssh                            # SSH protocol
    tmate                              # instant terminal sharing
    tmux                               # terminal multiplexer

    # System stuff ----------------------------------------------------- #
    gparted                            # partition manager
    usbutils                           # tools for usb
    pciutils                           # tools for pci

    # GPU & power stuff ------------------------------------------------ #
    amdvlk                             # AMD OSS Driver For Vulkan
    amdgpu_top                         # gpu usage
    thermald                           # thermal daemon
    tlp                                # advanced power management

    # Applications ----------------------------------------------------- #
    home-manager                       # "~/.config" manager
    onlyoffice-bin                     # office
    obs-studio                         # screen rec
    alacritty                          # terminal
    wezterm                            # term2
    foot                               # term3
    ranger                             # TUI file manager
    mpv                                # media player
    imv                                # image viewer
    firefox                            # browser
    librewolf                          # browser2
    qutebrowser                        # minimal browser
    ungoogled-chromium                 # ungoogled oss-chromium
    motrix                             # Download manager
    stremio                            # binge
    ani-cli                            # anime cli
    vscodium                           # IDE
    neovim                             # text editor
    neovide                            # GUI for neovim
    lazygit                            # TUI git tool
    telegram-desktop                   # telegram
    zen-browser                        # firefox fork

    # dependencies ----------------------------------------------------- #
    ripgrep                            # search with regex pattern
    nodePackages.nodejs                # framework for JS engine
    nodePackages.npm                   # npm 
    python3                            # python3
    python3Packages.pip                # py pkgs
    python3Packages.pandas             # pandas
    python3Packages.openpyxl           # py excel library
    python3Packages.pillow             # PIL fork
    tree-sitter                        # syntax parser
    stylua                             # lua formatter for nvim
    lua-language-server                # lua lsp
    gcc                                # GNU compiler collection
    gnumake                            # make system

  ]) ++ (with pkgs.vscode-extensions; [
    # vscodium extensions
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons
    wmaurer.change-case

  ]) ++ (with pkgs-stable; [

    # pkgs from stable branch

  ]);

}
