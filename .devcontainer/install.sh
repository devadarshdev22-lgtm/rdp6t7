#!/bin/bash
set -e

source .devcontainer/env.sh

echo "🧱 Installing Windows-style stable base..."

sudo apt-get update -y

sudo apt-get install -y --no-install-recommends \
xfce4 \
xfce4-terminal \
xvfb \
x11vnc \
novnc \
websockify \
dbus-x11 \
autocutsel \
git-lfs \
wget \
curl \
gnupg \
tzdata \
keyboard-configuration

# 🔥 FORCE CONFIG SKIP (this is key)
echo "tzdata tzdata/Areas select Etc" | sudo debconf-set-selections
echo "tzdata tzdata/Zones/Etc select UTC" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/layout select English (US)" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/variant select English (US)" | sudo debconf-set-selections

git lfs install

echo "🌐 Installing Chrome..."

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || true

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ./google-chrome-stable_current_amd64.deb || true

rm -f google-chrome-stable_current_amd64.deb

echo "✅ Install complete"