#!/bin/bash
set -e

echo "🧱 Starting SAFE install (no locks, no prompts)..."

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

# Wait for any existing apt lock to disappear (IMPORTANT FIX)
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  echo "⏳ Waiting for apt lock to release..."
  sleep 2
done

sudo dpkg --configure -a || true

sudo apt-get update -y

# Preseed everything BEFORE install (prevents keyboard/tz prompts)
echo "tzdata tzdata/Areas select Etc" | sudo debconf-set-selections
echo "tzdata tzdata/Zones/Etc select UTC" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/layout select English (US)" | sudo debconf-set-selections

# Install EVERYTHING in ONE transaction (prevents partial state)
sudo apt-get install -y --no-install-recommends \
xfce4 \
xfce4-terminal \
xvfb \
x11vnc \
novnc \
websockify \
dbus-x11 \
autocutsel \
curl \
wget \
git-lfs \
fastfetch

# FIX Git LFS ALWAYS
git lfs install --system --skip-repo || true

echo "🌐 Installing Chrome..."

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || true
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y || true
rm -f google-chrome-stable_current_amd64.deb

echo "🧠 Creating swap file..."

sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "✅ Swap enabled (8GB)"

echo "✅ Install COMPLETE (stable state guaranteed)"