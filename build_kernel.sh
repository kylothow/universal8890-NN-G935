#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=../gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

make exynos8890-hero2lte_defconfig
make -j4
