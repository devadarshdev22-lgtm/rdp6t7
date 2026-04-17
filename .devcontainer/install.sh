#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y \
xfce4 \
xfce4-terminal \
xvfb \
x11vnc \
novnc \
websockify \
dbus-x11 \
autocutsel \
wget \
gnupg \
curl

# Install Google Chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb || apt -f install -y

rm -f google-chrome-stable_current_amd64.deb

# Clean desktop clutter
rm -rf /home/vscode/Desktop/* || true