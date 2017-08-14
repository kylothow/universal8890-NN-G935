#!/bin/bash
#
# Copyright (C) 2017 Michele Beccalossi <beccalossi.michele@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

./build_kernel.sh 0
./build_kernel.sh 1

./build_kernel.sh 0
./build_kernel.sh 2

./build_kernel.sh 0
./build_kernel.sh 3

./build_kernel.sh 0
./build_kernel.sh 4

./build_kernel.sh 0

tput reset

echo ""
echo "=================================================================="
echo "START : FUNC_CUSTOM_CLEAN"
echo "=================================================================="
echo ""

echo "◊ Deleting log files..."
rm -f cfp_log.txt
rm -f build_kernel.log
echo ""
echo "◊ Deleting dtb compilation leftovers..."
rm -f arch/arm64/boot/dtb.img
rm -rf arch/arm64/boot/dtb/*
echo ""
echo "◊ Cleaning build folder..."
rm -f build/herolte/dtb
rm -f build/herolte/zImage
rm -f build/herolte/.version
rm -f build/hero2lte/dtb
rm -f build/hero2lte/zImage
rm -f build/hero2lte/.version

echo ""
echo "=================================================================="
echo "END   : FUNC_CUSTOM_CLEAN"
echo "=================================================================="
echo ""
