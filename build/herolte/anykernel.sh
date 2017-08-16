# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Primal Kernel by kylothow @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=herolte
device.name2=heroltebmc
device.name3=herolteskt
device.name4=heroltelgt
device.name5=heroltektt
} # end properties

# shell variables
block=/dev/block/platform/155a0000.ufs/by-name/BOOT;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod 640 $ramdisk/fstab.samsungexynos8890
chmod 640 $ramdisk/fstab.samsungexynos8890.fwup
chmod 750 $ramdisk/init.services.rc
chmod 750 $ramdisk/sbin/sysinit.sh


## AnyKernel install
dump_boot;

# begin ramdisk changes

if egrep -q "dream2lte|SM-G955" "/system/build.prop"; then
  ui_print " ";
  ui_print "Patching ramdisk for S8+ ported ROMs...";
  insert_line default.prop "ro.oem_unlock_supported=1" after "persist.security.ams.enforcing=1" "ro.oem_unlock_supported=1";
  replace_file init.environ.rc 750 dream2lte/init.environ.rc;
  insert_line init.samsungexynos8890.rc "service visiond /system/bin/visiond" after "start secure_storage" "\n# AIR\nservice visiond /system/bin/visiond\n    class main\n    user system\n    group system camera media media_rw\n";
  replace_file property_contexts 644 dream2lte/property_contexts;
  replace_file sbin/adbd 777 dream2lte/sbin/adbd;
  replace_file sepolicy 644 dream2lte/sepolicy;
  replace_file sepolicy_version 644 dream2lte/sepolicy_version;
  replace_file service_contexts 644 dream2lte/service_contexts;
fi;

# default.prop
patch_prop default.prop "ro.secure" "0";
patch_prop default.prop "ro.debuggable" "1";
patch_prop default.prop "persist.sys.usb.config" "mtp,adb";
insert_line default.prop "persist.service.adb.enable=1" after "persist.sys.usb.config=mtp,adb" "persist.service.adb.enable=1";
insert_line default.prop "persist.adb.notify=0" after "persist.service.adb.enable=1" "persist.adb.notify=0";

insert_line default.prop "ro.securestorage.support=false" after "debug.atrace.tags.enableflags=0" "ro.securestorage.support=false";
insert_line default.prop "ro.config.tima=0" after "ro.securestorage.support=false" "ro.config.tima=0";
insert_line default.prop "wlan.wfd.hdcp=disable" after "ro.config.tima=0" "wlan.wfd.hdcp=disable";

# init.samsungexynos8890.rc
insert_line init.samsungexynos8890.rc "import init.services.rc" after "import init.remove_recovery.rc" "import init.services.rc";
insert_line init.samsungexynos8890.rc "mount f2fs /dev/block/platform/155a0000.ufs/by-name/SYSTEM /system wait ro" after "mount ext4 /dev/block/platform/155a0000.ufs/by-name/SYSTEM /system wait ro" "    mount f2fs /dev/block/platform/155a0000.ufs/by-name/SYSTEM /system wait ro";

# end ramdisk changes

write_boot;

## end install

