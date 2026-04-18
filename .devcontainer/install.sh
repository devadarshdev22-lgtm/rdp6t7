#!/bin/bash

sudo apt-get install -y locales
sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    openbox \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    dbus-x11 \
    xterm \
    curl \
    ca-certificates

# Install Chrome (The 'Clean' Way)
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-linux.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update && sudo apt-get install -y google-chrome-stable

# Install Fastfetch & Chrome as you had them
sudo apt-get install -y fastfetch

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
| sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt-get update
sudo apt-get install -y google-chrome-stable
echo 'alias chrome="google-chrome --no-sandbox --disable-dev-shm-usage"' >> ~/.bashrc

# Create a wrapper script
echo '#!/bin/bash
/usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage "$@"' | sudo tee /usr/local/bin/google-chrome
sudo chmod +x /usr/local/bin/google-chrome

# ✅ Git LFS setup
git lfs install

echo "✅ Everything installed"