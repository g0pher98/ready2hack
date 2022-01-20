sudo apt install -y libpci-dev libpci-dev libusb-dev \
                    libusb-1.0-0-dev libjaylink0 libjaylink-dev
                    cmake libftdi1-dev

cd ~
git clone https://github.com/flashrom/flashrom
cd ./flashrom
make
make install


# https://www.flashrom.org/Flashrom/0.9.6/Supported_Hardware