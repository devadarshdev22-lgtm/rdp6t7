#!/bin/bash
set -e

echo "🪟 Starting Cloud Desktop..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Virtual display (must be stable first)
Xvfb :1 -screen 0 1280x800x24 &
sleep 3

# Desktop
dbus-launch --exit-with-session startxfce4 &
sleep 6

# VNC server (must bind BEFORE websockify)
x11vnc -display :1 -forever -shared -rfbport 5900 -nopw -quiet &
sleep 2

# VERIFY noVNC path dynamically (THIS FIXES BLANK PAGE)
NOVNC_PATH=$(ls /usr/share | grep novnc | head -n 1)

if [ -z "$NOVNC_PATH" ]; then
  echo "❌ noVNC not found"
else
  echo "✅ Using noVNC path: /usr/share/$NOVNC_PATH"
fi

# Websockify (now safe)
websockify --web=/usr/share/$NOVNC_PATH 6080 localhost:5900 &

# Chrome auto start
(
sleep 10
command -v google-chrome >/dev/null && DISPLAY=:1 google-chrome --no-sandbox https://google.com &
) &

# Fastfetch
(
sleep 4
fastfetch || true
) &

echo "✅ Desktop should now work at port 6080"