#!/bin/bash
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Clean up old locks
sudo rm -f /tmp/.X1-lock

# 1. Start Xvfb (Virtual Monitor)
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

# 2. Start XFCE (Much more stable than KDE for this)
startxfce4 &
sleep 3

# 3. Start VNC and noVNC
x11vnc -display :1 -forever -nopw -shared -rfbport 5900 -noxdamage &
websockify --web=/usr/share/novnc 6080 localhost:5900

# Auto-launch Chrome with the correct flags
(
  sleep 5
  export DISPLAY=:1
  google-chrome --no-sandbox --disable-dev-shm-usage --start-maximized https://google.com &
) &