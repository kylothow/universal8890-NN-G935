#!/bin/bash

KERNEL_NAME="Primal_Kernel"
KERNEL_VERSION="2.0.0"
KERNEL_BETA="true"

if [ $KERNEL_BETA == true ]; then
	KERNEL_VERSION+=β
fi
export LOCALVERSION=-${KERNEL_NAME}-v${KERNEL_VERSION}

export ARCH=arm64
export CROSS_COMPILE=../gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

make exynos8890-hero2lte_defconfig
make -j4 2>&1 | tee -a ./build_kernel.log
