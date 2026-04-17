#!/bin/bash
set -e

source .devcontainer/env.sh

echo "🪟 Starting Windows-style Cloud Desktop..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Virtual display
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

# XFCE desktop (Windows-like UI)
dbus-launch --exit-with-session startxfce4 &
sleep 5

# Clipboard
autocutsel -fork
autocutsel -selection PRIMARY -fork

# VNC
x11vnc -display :1 -forever -shared -rfbport 5900 -nopw -quiet &

# noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# Windows-like behavior: auto-open Chrome
(
sleep 10
DISPLAY=:1 google-chrome --no-sandbox https://google.com &
) &

echo "✅ Desktop ready"