#!/bin/bash
set -e

echo "🪟 Starting desktop..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

Xvfb :1 -screen 0 1280x800x24 &
sleep 2

dbus-launch --exit-with-session startxfce4 &
sleep 5

x11vnc -display :1 -forever -shared -rfbport 5900 -nopw -quiet &
websockify --web=/usr/share/novnc 6080 localhost:5900 &

# Auto Chrome (safe check)
(
sleep 8
command -v google-chrome >/dev/null && DISPLAY=:1 google-chrome --no-sandbox https://google.com &
) &

# Fastfetch (safe)
(
sleep 3
fastfetch || true
) &

echo "✅ Desktop ready"