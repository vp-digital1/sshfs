#!/bin/sh

set -e

sudo ln -svf $(which python3) /usr/bin/python3
sudo python3 -m pip install pytest meson
wget https://github.com/ninja-build/ninja/releases/download/v1.7.2/ninja-linux.zip
unzip ninja-linux.zip
chmod 755 ninja
sudo chown root:root ninja
sudo mv -fv ninja /usr/local/bin
valgrind --version
ninja --version
meson --version

# Install fuse
wget https://github.com/libfuse/libfuse/archive/master.zip
unzip master.zip
cd libfuse-master
mkdir build
cd build
export CC=gcc-6
meson ..
ninja
sudo ninja install
test -e /usr/local/lib/pkgconfig || sudo mkdir /usr/local/lib/pkgconfig
sudo mv /usr/local/lib/*/pkgconfig/* /usr/local/lib/pkgconfig/
ls -d1 /usr/local/lib/*-linux-gnu | sudo tee /etc/ld.so.conf.d/usrlocal.conf
sudo ldconfig

# Setup ssh
ssh-keygen -b 768 -t rsa -f ~/.ssh/id_rsa -P ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh -o "StrictHostKeyChecking=no" localhost echo "SSH connection succeeded"
