#!/system/bin/sh
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

resetprop=/sbin/resetprop
fstrim=/system/xbin/fstrim

mount -o rw,remount /
mount -o rw,remount /system

# deepsleep fix
for i in `ls /sys/class/scsi_disk/`; do
	cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
	if [ $? -eq 0 ]; then
		echo 'temporary none' > /sys/class/scsi_disk/$i/cache_type
	fi
done

# alter system properties
$resetprop -n ro.boot.veritymode "enforcing"
$resetprop -n ro.boot.verifiedbootstate "green"
$resetprop -n ro.boot.flash.locked "1"
$resetprop -n ro.boot.ddrinfo "00000001"
$resetprop -n ro.boot.warranty_bit "0"
$resetprop -n ro.warranty_bit "0"
$resetprop -n ro.fmp_config "1"
$resetprop -n ro.boot.fmp_config "1"
$resetprop -n sys.oem_unlock_allowed "0"

# trim on boot
$fstrim -v /system
$fstrim -v /data
$fstrim -v /cache

# init.d support
if [ ! -e /system/etc/init.d ]; then
	mkdir /system/etc/init.d
	chown -R root.root /system/etc/init.d
	chmod -R 755 /system/etc/init.d
fi

# start init.d
for file in /system/etc/init.d/*; do
	sh $file >/dev/null
done

mount -o ro,remount /
mount -o ro,remount /system
