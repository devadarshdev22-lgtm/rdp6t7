#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "🧱 Windows Cloud OS setup starting..."

sudo apt-get update -y

sudo apt-get install -y \
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
fastfetch

# 🔧 Git LFS FIX (critical)
git lfs install --system --skip-repo

# Force repair hooks if broken
git lfs update --force || true

echo "🌐 Installing Chrome..."

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || true

sudo apt install -y ./google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y || true

rm -f google-chrome-stable_current_amd64.deb

echo "🧹 Cleaning system..."
rm -rf /home/vscode/Desktop/* || true

echo "✅ Install complete"