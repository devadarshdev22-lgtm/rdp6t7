#!/bin/bash

# Avoid Codespaces race condition
sleep 2

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# ✅ CRITICAL FIX: X11 socket dir must exist
sudo mkdir -p /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix

# Clean old processes safely
pkill -9 Xvfb x11vnc websockify openbox google-chrome-stable 2>/dev/null || true

rm -f /tmp/.X1-lock
rm -rf /tmp/.X11-unix/X1

# Start virtual display
Xvfb :1 -screen 0 1366x768x16 \
  +extension RANDR +extension RENDER +extension GLX \
  > /tmp/xvfb.log 2>&1 &
sleep 2

# Window manager
dbus-launch openbox > /tmp/openbox.log 2>&1 &
sleep 1

# VNC server
x11vnc -display :1 \
  -forever -nopw -shared \
  -rfbport 5900 \
  -noxdamage -ncache 10 \
  > /tmp/x11vnc.log 2>&1 &

# Web VNC bridge
websockify --web=/usr/share/novnc 6080 localhost:5900 \
  > /tmp/websockify.log 2>&1 &

# Launch Chrome
(
  sleep 3
  DISPLAY=:1 google-chrome-stable \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --start-maximized \
    --no-first-run \
    https://google.com
) &

echo "🚀 VNC is running at http://localhost:6080"