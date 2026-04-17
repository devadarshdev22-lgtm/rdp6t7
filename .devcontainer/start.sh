#!/bin/bash
set -e

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

echo "🪟 Starting Windows 11 Cloud Desktop..."

# Virtual display
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

# XFCE desktop
dbus-launch --exit-with-session startxfce4 &
sleep 5

# Clipboard sync
autocutsel -fork
autocutsel -selection PRIMARY -fork

# VNC
x11vnc -display :1 -forever -shared -rfbport 5900 -nopw -quiet &

# noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# 🧠 AUTO FIX LFS EVERY START (important)
(
while true; do
  command -v git-lfs >/dev/null 2>&1 || sudo apt-get install -y git-lfs
  git lfs install --system --skip-repo || true
  sleep 60
done
) &

# 🖥 AUTO CHROME (Windows default browser vibe)
(
sleep 10
DISPLAY=:1 google-chrome --no-sandbox https://google.com &
) &

# 📊 FASTFETCH (Windows system info style)
(
sleep 6
clear
fastfetch || true
) &

echo "✅ Windows Cloud OS ready at http://localhost:6080"