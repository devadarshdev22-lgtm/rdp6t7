#!/bin/bash
set -e

echo "🚀 Launching KDE desktop environment..."

export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-vscode
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

export DEBIAN_FRONTEND=noninteractive

echo "🖥 Starting virtual display..."
Xvfb :1 -screen 0 1280x800x24 &

sleep 2

echo "🔌 Starting DBus session..."
dbus-launch --exit-with-session startplasma-x11 &

sleep 6

echo "🖥 Starting VNC server..."
x11vnc -display :1 -forever -nopw -shared -bg

echo "🌐 Starting noVNC..."
websockify --web=/usr/share/novnc 6080 localhost:5900