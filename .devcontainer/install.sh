#!/bin/bash
set -e

echo "📦 Installing KDE + VNC stack (stable)..."

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install -y --no-install-recommends \
  kde-plasma-desktop \
  plasma-workspace \
  x11-xserver-utils \
  xvfb \
  x11vnc \
  novnc \
  websockify \
  dbus-x11 \
  autocutsel \
  git-lfs

echo "🧠 Verifying installs..."

command -v Xvfb || (echo "❌ Xvfb missing" && exit 1)
command -v x11vnc || (echo "❌ x11vnc missing" && exit 1)
command -v websockify || (echo "❌ websockify missing" && exit 1)

echo "✅ KDE install complete"