#!/usr/bin/env bash
set -euo pipefail

echo "Installing YouTube TV (Leanback) for Linux..."

APP_NAME="YouTube TV 4K"
SCRIPT_PATH="$HOME/.local/bin/yttv.sh"
DESKTOP_PATH="$HOME/.local/share/applications/youtube-tv.desktop"

# ─── PREREQUISITES ─────────────────────────────────────────────
if ! command -v flatpak >/dev/null 2>&1; then
  echo "Error: flatpak is not installed."
  exit 1
fi

if ! flatpak info org.mozilla.firefox >/dev/null 2>&1; then
  echo "Installing Firefox Flatpak..."
  flatpak install -y flathub org.mozilla.firefox
fi

# ─── CONFIG ───────────────────────────────────────────────────
URL="https://www.youtube.com/tv"
UA="Mozilla/5.0 (PS4; Leanback Shell) Gecko/20100101 Firefox/65.0 LeanbackShell/01.00.01.75 Sony PS4"

PROFILE_NAME="youtube_leanback"
PROFILE_DIR="$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/$PROFILE_NAME"

mkdir -p "$HOME/.local/bin"

# ─── CREATE PROFILE ───────────────────────────────────────────
if [ ! -d "$PROFILE_DIR" ]; then
  echo "Creating Firefox profile..."
  flatpak run org.mozilla.firefox --no-remote -CreateProfile "$PROFILE_NAME $PROFILE_DIR" >/dev/null 2>&1 || true
fi

# ─── CONFIG USER PREFS ────────────────────────────────────────
mkdir -p "$PROFILE_DIR"

cat > "$PROFILE_DIR/user.js" <<EOF
user_pref("general.useragent.override", "$UA");
user_pref("media.eme.enabled", true);
user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("media.gmp-widevinecdm.autoupdate", true);
EOF

# ─── CREATE LAUNCH SCRIPT ─────────────────────────────────────
cat > "$SCRIPT_PATH" <<EOF
#!/usr/bin/env bash

flatpak run org.mozilla.firefox \
  --no-remote \
  -profile "$PROFILE_DIR" \
  --kiosk "$URL"
EOF

chmod +x "$SCRIPT_PATH"

# ─── DESKTOP ENTRY ────────────────────────────────────────────
mkdir -p "$(dirname "$DESKTOP_PATH")"

cat > "$DESKTOP_PATH" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$SCRIPT_PATH
Type=Application
Icon=im-youtube
Categories=Network;
StartupNotify=false
Terminal=false
EOF

echo
echo "✅ Installation complete!"
echo "You can now launch YouTube TV or add it to Steam."
