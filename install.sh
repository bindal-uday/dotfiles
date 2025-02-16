sudo nix flake update --extra-experimental-fetures 'nix-command flakes'
sudo nixos-install --root /mnt --flake /mnt/dotfiles#nixos

