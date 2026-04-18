#!/bin/bash

sleep 2

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode

mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Fix X11 socket issue (still needed sometimes)
sudo mkdir -p /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix

# Kill old sessions
pkill -9 kasmvncserver Xvfb openbox chrome 2>/dev/null || true

# Start KasmVNC server
kasmvncserver :1 \
  -geometry 1366x768 \
  -depth 16 \
  -websocketPort 6080 \
  -interface 0.0.0.0 \
  > /tmp/kasmvnc.log 2>&1 &

# Wait until display is ready (FIXES 502)
until xdpyinfo -display :1 >/dev/null 2>&1; do
  echo "⏳ Waiting for display..."
  sleep 1
done

# Start window manager
dbus-launch openbox > /tmp/openbox.log 2>&1 &

# Launch Chrome
(
  sleep 3
  DISPLAY=:1 google-chrome-stable \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --start-maximized \
    https://google.com
) &

echo "🚀 KasmVNC running on port 6080"