{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    font-awesome # for waybar icons
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
