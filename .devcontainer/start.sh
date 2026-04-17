#!/bin/bash
set -e

echo "🚀 Starting KDE noVNC..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

export DEBIAN_FRONTEND=noninteractive

echo "🖥 Starting Xvfb..."
Xvfb :1 -screen 0 1280x800x24 &

sleep 2

echo "🔌 Starting DBus..."
dbus-launch --exit-with-session startplasma-x11 &

sleep 5

echo "🖥 Starting VNC..."
x11vnc -display :1 -forever -nopw -shared -bg

echo "🌐 Starting noVNC..."
websockify --web=/usr/share/novnc 6080 localhost:5900