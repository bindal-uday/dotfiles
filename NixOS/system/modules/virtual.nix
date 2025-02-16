{config, lib, pkgs, ...}:

{

  virtualisation = { 
    # docker
    docker.enable = true;
    # podman
    podman.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker                             # container pkg
    docker-compose                     # multi-container cli tool
    distrobox                          # docker wrapper
    distrobox-tui                      # TUI for distrobox
    lazydocker                         # TUI for docker
    podman                             # pods / containers
    podman-tui                         # TUI for podman

  ];
}
