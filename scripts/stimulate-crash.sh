#!/usr/bin/env bash
set -euo pipefail

# Default values
SECRETS_PATH="/etc/secrets/secrets.json"
CRASH_DIR_BASE="/tmp"

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
echo "Simulating crash event..."

# Create fake crash logs
CRASH_DIR="${CRASH_DIR_BASE}/fake-crash-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$CRASH_DIR"

echo "This is a simulated dmesg crash log." > "$CRASH_DIR/dmesg-current.log"
echo "This is a simulated journal crash log." > "$CRASH_DIR/journal-last-crash.log"
echo "🚨 *SIMULATED CRASH DETECTED* at $(date)" > "$CRASH_DIR/crash-summary.txt"

# Read bot token and chat ID
BOT_TOKEN=$(jq -r .bot_token "$SECRETS_PATH")
CHAT_ID=$(jq -r .chat_id "$SECRETS_PATH")

# Send crash summary
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d parse_mode="MarkdownV2" \
  --data-urlencode text="$(cat "$CRASH_DIR/crash-summary.txt")"

# Attach dmesg log
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
  -F chat_id="$CHAT_ID" \
  -F document=@"$CRASH_DIR/dmesg-current.log" \
  -F caption="📄 dmesg-current.log (simulated)"

# Attach journal log
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
  -F chat_id="$CHAT_ID" \
  -F document=@"$CRASH_DIR/journal-last-crash.log" \
  -F caption="📄 journal-last-crash.log (simulated)"

echo "Simulated crash logs sent successfully!"
