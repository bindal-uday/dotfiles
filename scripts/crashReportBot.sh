#!/usr/bin/env bash
set -euo pipefail

# Default values
SECRETS_PATH="/home/error/dotfiles/.private/secrets.json"
SECRETS_ENV_VAR="/home/error/dotfiles/.private/secrets.env"
CRASH_DIR_BASE="/var/log/crash-logs"

# --- Parse command line flags ---
while getopts "s:" opt; do
  case ${opt} in
    s )
      SECRETS_PATH="$OPTARG"
      ;;
    \? )
      echo "Usage: $0 [-s secrets_path]"
      exit 1
      ;;
  esac
done

echo "Using secrets from: $SECRETS_PATH"
echo "Capture crash event..."

# Create a unique folder for this crash
CRASH_DIR="${CRASH_DIR_BASE}/crash-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$CRASH_DIR"

# Read bot token and chat ID
BOT_TOKEN=$(jq -r .bot_token "$SECRETS_PATH")
CHAT_ID=$(jq -r .chat_id "$SECRETS_PATH")

# Save critical logs
journalctl --boot=-1 --priority=3 > "$CRASH_DIR/journal-last-crash.log"
dmesg > "$CRASH_DIR/dmesg-current.log"

# Create crash summary
generate_crash_message() {
  local timestamp
  timestamp=$(date)

  {
    echo "🚨 <b>System Crash Detected</b>"
    echo "🕒 <b>Time:</b> $timestamp"
    echo ""
    echo "<b>Recent Critical Journal Errors:</b>"
    echo "<pre>"
    tail -n 12 "$CRASH_DIR/journal-last-crash.log"
    echo "</pre>"
    echo ""
    echo "<b>Recent Kernel Logs (dmesg):</b>"
    echo "<pre>"
    tail -n 12 "$CRASH_DIR/dmesg-current.log"
    echo "</pre>"
  } > "$CRASH_DIR/crash-summary.txt"
}

# Send crash summary message
generate_crash_message
CRASH_MSG=$(<"$CRASH_DIR/crash-summary.txt")
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d parse_mode="HTML" \
  --data-urlencode text="$CRASH_MSG"

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

echo "Crash logs captured and sent at $(date)" >> ${CRASH_DIR_BASE}/capture.log
