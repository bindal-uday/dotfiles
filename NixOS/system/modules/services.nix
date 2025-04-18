{ config, lib, pkgs, ... }:

{
  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad.accelSpeed = "0.4";
    mouse.middleEmulation = false;
  };

  # dbus services
  services = {
    dbus.enable = true;
    fwupd.enable = true;
  };

  # Logging
  services.journald.extraConfig = ''
    Storage=persistent
  '';

  systemd.services.crashReportBot = {
    description = "Capture logs & send to telegram bot";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ coreutils util-linux curl jq ];
    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      ExecStart = pkgs.writeShellScript "crashReportBot" ''
        ${builtins.readFile ./../../../scripts/crashReportBot.sh}
      '';
    };
  };

  # virtual fs
  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };

  # default behaviour
  services.logind = {
    powerKey = "suspend-then-hibernate";
    lidSwitch = "suspend-then-hibernate";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # TPM
  boot.initrd.systemd.tpm2.enable = false;
  systemd = {
    tpm2.enable = false;
    services = {
      "tpm2.tagret" = {
        enable = false;
      };
      "dev-tpm0.device" = {
        enable = false;
      };
      "dev-tpmrm0.device" = {
        enable = false;
      };
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    # list of pkgs
    libinput
    libinput-gestures
    gvfs
  ];
}
