#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export TZ=Etc/UTC

sudo apt-get update

sudo apt-get install -y --no-install-recommends \
    locales \
    openbox \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    dbus-x11 \
    xterm \
    curl \
    ca-certificates \
    fastfetch \
    git-lfs

# Locale
sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

# Chrome install (clean)
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
  | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-linux.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt-get update
sudo apt-get install -y google-chrome-stable

# Chrome wrapper
echo '#!/bin/bash
/usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage "$@"' \
| sudo tee /usr/local/bin/google-chrome

sudo chmod +x /usr/local/bin/google-chrome

git lfs install

echo "✅ Everything installed"