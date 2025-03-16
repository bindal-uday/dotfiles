{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    font-awesome # for waybar icons
    jetbrains-mono
    geist-font
    fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.geist-mono
  ];
}
