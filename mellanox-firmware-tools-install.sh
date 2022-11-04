#!/usr/bin/bash
wget https://www.mellanox.com/downloads/MFT/mft-4.21.0-99-x86_64-deb.tgz && \
tar -xf mft-4.21.0-99-x86_64-deb.tgz && \
cd mft-4.21.0-99-x86_64-deb && \
sudo ./install.sh
