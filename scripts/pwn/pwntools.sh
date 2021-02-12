sudo apt -y install \
    python2.7-dev \
    python-pip \
    python-setuptools
    libssl-dev \
    libffi-dev

python2 -m pip install pwntools
sudo apt -y install libcapstone-dev