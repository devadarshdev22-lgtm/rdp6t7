#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

# Core packages
sudo apt-get install -y --no-install-recommends \
  openbox \
  dbus-x11 \
  curl \
  ca-certificates \
  wget \
  x11-utils \
  git-lfs \
  fastfetch

# ✅ Install KasmVNC (latest)
wget -qO kasmvnc.deb https://github.com/kasmtech/KasmVNC/releases/latest/download/kasmvncserver_amd64.deb
sudo apt install -y ./kasmvnc.deb
rm kasmvnc.deb

# Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
  | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-linux.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt-get update
sudo apt-get install -y google-chrome-stable

git lfs install

echo "✅ Install complete"