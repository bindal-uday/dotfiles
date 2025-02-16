# Linux dotfiles

Contains configuration files for my Linux and work env

## Installation

### Pre-requisites

Connect Internet & Parition Drive

```bash
wpa_passphrase ESSID | sudo tee /etc/wpa_supplicant.conf
systemctl restart wpa_supplicant

sudo cfdisk /dev/sdX
( /mnt/boot , /mnt , /mnt/home )
cd /mnt
```

```bash
git clone https://github.com/bindal-uday/dotfiles
cd dotfiles
sudo nix flake update --extra-experimental-features 'nix-command flakes'
nixos-generate-config --dir NixOS/system
sudo nixos-install --root /mnt --flake ~/dotfiles#nixos -L
nix run --no-write-lock-file --impure github:nix-community/home-manager -- switch   --flake ~/dotfiles
```

and finally

```bash
sudo nixos-rebuild switch --flake ~/dotfiles -L
home-manager switch --flake ~/dotfiles
```
