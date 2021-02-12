sudo dpkg --add-architecture i386
sudo apt-get update

sudo apt -y install \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386