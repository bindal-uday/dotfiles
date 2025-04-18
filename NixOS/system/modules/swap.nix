{ config, lib, pkgs, ... }:

{
  # 1. Enable ZRAM swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "lz4";
  };

  # 2. Set up minimal real swap
  swapDevices = [
    { device = "/swapfile"; size = 512; } # 512MB swapfile
  ];

  # 3. Enable ZSWAP
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4"       # fast compression
    "zswap.max_pool_percent=20"  # only 20% of RAM for zswap cache
    "zswap.zpool=zsmalloc"
  ];

  # 4. Tweak swap behavior
  boot.kernel.sysctl = {
    "vm.swappiness" = 150;  # swap early but still favor RAM
    "vm.page-cluster" = 0;  # write minimal swap pages together (more responsive)
  };

  # 5. Ensure swapfile permissions
  systemd.tmpfiles.rules = [
    "f /swapfile 0600 root root -"  # secure swapfile
  ];

  # 6. Tools (Optional but useful)
  environment.systemPackages = with pkgs; [
    util-linux # swapon, free, zramctl, etc
  ];
}
