#!/bin/bash
export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# 1. HARD CLEANUP - Force kill everything before starting
sudo killall -9 Xvfb x11vnc websockify openbox google-chrome-stable 2>/dev/null
sudo rm -f /tmp/.X1-lock
sudo rm -rf /tmp/.X11-unix/X1

# 2. START VIRTUAL DISPLAY (Lower depth = Much higher speed)
# Using 16-bit color depth (x16) instead of 24-bit makes it 40% faster.
Xvfb :0 -screen 0 1366x768x16 +extension RANDR +extension RENDER +extension GLX &
sleep 2

# 3. START WINDOW MANAGER (Openbox is tiny and fast)
dbus-launch openbox &
sleep 1

# 4. START VNC (Optimized flags for lag)
# -ncache 10 caches pixels on your side to reduce internet lag
# -noxdamage stops redundant screen refreshes
x11vnc -display :0 -forever -nopw -shared -rfbport 5900 -noxdamage -ncache 10 &

# 5. START WEB BRIDGE
websockify --web=/usr/share/novnc 6080 localhost:5900 &

# 6. START CHROME (Maximized and fast)
(
  sleep 3
  google-chrome-stable --no-sandbox --disable-dev-shm-usage \
    --disable-gpu --disable-software-rasterizer \
    --start-maximized --no-first-run https://google.com
) &

echo "🚀 Super-Lightweight VNC Started!"