#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install libncurses5-dev
sudo apt-get install build-essential
sudo apt-get install bc
sudo apt-get install lbzip2
sudo apt-get install qemu-user-static
sudo apt-get install python

#Create a folder
mkdir jetson_xavier_nx
cd jetson_xavier_nx

#Download required files
# a) L4T Jetson Driver Package:
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t186/jetson_linux_r32.6.1_aarch64.tbz2

# b) L4T Sample Root File System:
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t186/tegra_linux_sample-root-filesystem_r32.6.1_aarch64.tbz2

# c) L4T Sources:
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/sources/t186/public_sources.tbz2

# d) GCC Tool Chain for 64-bit BSP:
wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz

# Extract files
sudo tar xpf jetson_linux_r32.6.1_aarch64.tbz2
cd Linux_for_Tegra/rootfs/
sudo tar xpf ../../tegra_linux_sample-root-filesystem_r32.6.1_aarch64.tbz2
cd ../../
tar -xvf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
sudo tar -xjf public_sources.tbz2
tar -xjf Linux_for_Tegra/source/public/kernel_src.tbz2

# Apply RT patches
cd kernel/kernel-4.9/
./scripts/rt-patch.sh apply-patches

# Configure and compile the kernel
TEGRA_KERNEL_OUT=jetson_xavier_kernel
mkdir $TEGRA_KERNEL_OUT
export CROSS_COMPILE=$HOME/jetson_xavier_nx/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
make ARCH=arm64 O=$TEGRA_KERNEL_OUT tegra_defconfig
make ARCH=arm64 O=$TEGRA_KERNEL_OUT menuconfig
make ARCH=arm64 O=$TEGRA_KERNEL_OUT -j4
sudo cp jetson_xavier_kernel/arch/arm64/boot/Image $HOME/jetson_xavier_nx/Linux_for_Tegra/kernel/Image
sudo cp -r jetson_xavier_kernel/arch/arm64/boot/dts/* $HOME/jetson_xavier_nx/Linux_for_Tegra/kernel/dtb/
sudo make ARCH=arm64 O=$TEGRA_KERNEL_OUT modules_install INSTALL_MOD_PATH=$HOME/jetson_xavier_nx/Linux_for_Tegra/rootfs/

cd $HOME/jetson_xavier_nx/Linux_for_Tegra/rootfs/
sudo tar --owner root --group root -cjf kernel_supplements.tbz2 lib/modules
sudo mv kernel_supplements.tbz2  ../kernel/

cd ..
sudo ./apply_binaries.sh

# Generate Jetson Xavier NX image
cd tools
sudo ./jetson-disk-image-creator.sh -o jetson_xavier_nx.img -b jetson-xavier-nx-devkit
