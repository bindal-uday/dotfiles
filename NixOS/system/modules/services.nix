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

  systemd.services.capture-crash-logs =
  let
    secretsPath = "/etc/secrets/secrets.json";
    crashLogBaseDir = "/var/log/crash-logs";
  in {
    wantedBy = [ "multi-user.target" ];
    description = "Capture crash logs and send via Telegram with attachments";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "capture-crash-logs"
      ''
        set -e

        # Create a unique folder for this crash
        CRASH_DIR="${crashLogBaseDir}/$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$CRASH_DIR"

        # Save critical logs
        journalctl --boot=-1 --priority=3 > "$CRASH_DIR/journal-last-crash.log"
        dmesg > "$CRASH_DIR/dmesg-current.log"

        # Create crash summary
        echo "🚨 *CRASH DETECTED* at $(date)" > "$CRASH_DIR/crash-summary.txt"
        echo "" >> "$CRASH_DIR/crash-summary.txt"
        echo "*Recent critical journal errors:*" >> "$CRASH_DIR/crash-summary.txt"
        tail -n 20 "$CRASH_DIR/journal-last-crash.log" >> "$CRASH_DIR/crash-summary.txt"

        # Read bot token and chat ID securely
        BOT_TOKEN=$(jq -r .bot_token ${secretsPath})
        CHAT_ID=$(jq -r .chat_id ${secretsPath})

        # Send crash summary message
        curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
          -d chat_id="$CHAT_ID" \
          -d parse_mode="MarkdownV2" \
          --data-urlencode text="$(cat $CRASH_DIR/crash-summary.txt)"

        # Attach dmesg log
        curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
          -F chat_id="$CHAT_ID" \
          -F document=@"$CRASH_DIR/dmesg-current.log" \
          -F caption="📄 dmesg-current.log"

        # Attach journal crash log
        curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
          -F chat_id="$CHAT_ID" \
          -F document=@"$CRASH_DIR/journal-last-crash.log" \
          -F caption="📄 journal-last-crash.log"

        echo "Crash logs captured and sent at $(date)" >> ${crashLogBaseDir}/capture.log
      '';

      # Grant read-only access to secrets
      ReadOnlyPaths = [ secretsPath ];
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
