#!/bin/bash

echo "📦 Installing XFCE + VNC stack..."

sudo apt-get update

# Core desktop + VNC
sudo apt-get install -y --no-install-recommends \
xfce4 \
xfce4-terminal \
xvfb \
x11vnc \
novnc \
websockify \
dbus-x11 \
autocutsel \
x11-xserver-utils \
curl \
gnupg \
git-lfs

# ✅ Install fastfetch
sudo apt-get install -y fastfetch

# ✅ Install Google Chrome
echo "🌐 Installing Chrome..."
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
| sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt-get update
sudo apt-get install -y google-chrome-stable
echo 'alias chrome="google-chrome --no-sandbox --disable-dev-shm-usage"' >> ~/.bashrc

# ✅ Git LFS setup
git lfs install

echo "✅ Everything installed"