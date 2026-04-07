#!/usr/bin/env bash
set -e

echo "Installing YouTube TV (Leanback) for Linux..."

APP_NAME="YouTube TV 4k"
SCRIPT_PATH="$HOME/.local/bin/yttv.sh"
DESKTOP_PATH="$HOME/.local/share/applications/youtube-tv.desktop"

mkdir -p "$HOME/.local/bin"

cat > "$SCRIPT_PATH" << 'EOF'
#!/usr/bin/env bash

URL="https://www.youtube.com/tv"
UA="Mozilla/5.0 (PlayStation 4 3.11) AppleWebKit/537.73"

brave-browser \
  --kiosk "$URL" \
  --user-agent="$UA" \
  --start-fullscreen \
  --enable-gpu-rasterization \
  --ignore-gpu-blocklist
EOF

chmod +x "$SCRIPT_PATH"

mkdir -p "$(dirname "$DESKTOP_PATH")"

cat > "$DESKTOP_PATH" << EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$SCRIPT_PATH
Type=Application
Icon=im-youtube
Categories=Network;
StartupNotify=false
EOF

echo
echo "✅ Installation complete!"
echo "You can now launch YouTube TV or add it to Steam."
