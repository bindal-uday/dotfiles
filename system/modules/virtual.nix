{config, lib, pkgs, ...}:

{

  virtualisation.docker.enable = true;

  environment.systemPackages = (with pkgs; [

    distrobox                          # docker wrapper
    distrobox-tui                      # TUI for distrobox
    lazydocker                         # TUI for docker
    docker                             # container pkg
    docker-compose                     # multi-container cli tool

  ]);
}
