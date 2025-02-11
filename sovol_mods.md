---
title: Modifications by Sovol
layout: page
nav_order: 3
parent: Firmware
has_toc: false
---
# Modifications by Sovol / Makerbase
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

Please note that this is just work-in-progress.  
The changes listed here may not be complete and are just quickly tested.  
Thanks to Vasyl Gontar and nubecoder for their additions/corrections to this list.

  * KlipperScreen
    * incomplete ".git" directory (throws errors on KIAUH update page)
    * revision must be around 926d78de01efb114d00e021364b04bbe6f28690b (Mar 8 2023)
    * translations are younger (~ Jun 16 2023)
    * some changes (theme "sovol dark" instead of "z-bolt")


  * fluidd: git information removed?
  * mainsail: git information removed?

  * added power loss recovery (plr)
    * see https://github.com/The--Captain/plr-klipper
    * ~/plr.sh modified? old version?: G31 (called from CANCEL_PRINT) calls ~/clear_plr.sh

  * Kernel:
    * (unsure, if changed - but not working for all later kernels -> spi-dev missing)
      * "/boot/dtb/rockchip/overlay/rockchip-fixup.scr"
      * "/boot/dtb/rockchip/rk3328-roc-cc.dtb"
      * see https://irq5.io/2018/07/24/boot-time-device-tree-overlays-with-u-boot/
      * see https://github.com/redrathnure/armbian-mkspi
    * Serial console (u-boot messages): 1500000,8,n,1

  * u-boot (bootloader)
    * <del>Sovols bootloader allows booting from an external device (USB-stick)</del>
    * [Booting](booting.html) from an external device (USB-stick)


----

## Files in /root
  * auto_refresh + auto_refresh.cpp
    * update helper
    * used by `makerbase-auto-fresh.service`
  * beep.sh
    * beep if touch is pressed
    * used by `makerbase-beep.service`
  * get_id + get_id.cpp
    * retrieves serial connection
    * used by `makerbase-byid.service`
  * set-timezone.sh
    * update timezone, fetch time every 3 seconds via NTP (syslog spammer)
    * used by `makerbase-timezone-monitor.service`
  * soft_shutdown.sh
    * sets up GPIOs for "supper" capacitor, effectively does nothing
    * used by `makerbase-soft-shutdown.service`
  * hid-flash
    * **unknown binary, source code missing**
    * ~~probably precompiled `klipper/lib/hidflash`~~
    * probably taken from [MS1987/STM32_HID_Bootloader](https://github.com/MS1987/STM32_HID_Bootloader/)\
      (thanks to nubecoder for [investigation](https://github.com/torte71/InsideSovolKlipperScreen/issues/3#issue-2781797653))
    * <details markdown="block"><summary>click to see references</summary>
```
/home/mks/ff-hid-flash.txt:Binary file /home/mks/_root/hid-flash matches
/home/mks/klipper/src/stm32/Makefile:lib/hidflash/hid-flash:
/home/mks/klipper/src/stm32/Makefile:   @echo "  Building hid-flash"
/home/mks/klipper/src/stm32/Makefile:flash: $(OUT)klipper.bin lib/hidflash/hid-flash
/home/mks/klipper/docs/Bootloaders.md:The hid-flash program is used to upload a binary to the bootloader. You
/home/mks/klipper/docs/Bootloaders.md:~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
/home/mks/klipper/docs/Bootloaders.md:As with the STM32F1, the STM32F4 uses the hid-flash tool to upload binaries to
/home/mks/klipper/docs/Bootloaders.md:hid-flash.
/home/mks/klipper/lib/hidflash/changes.diff: EXECUTABLE = hid-flash
/home/mks/klipper/lib/hidflash/changes.diff:+   @echo "    hid-flash requires libusb-1.0, please install with:"
/home/mks/klipper/lib/hidflash/changes.diff:+* This version of hid-flash has been modified to work with Klipper.
/home/mks/klipper/lib/hidflash/changes.diff:-    printf("Usage: hid-flash <bin_firmware_file> <comport> <delay (optional)>\n");
/home/mks/klipper/lib/hidflash/changes.diff:+    printf("Usage: hid-flash <bin_firmware_file> <comport (optional)> <delay (optional)>\n");
/home/mks/klipper/lib/hidflash/Makefile:EXECUTABLE = hid-flash
/home/mks/klipper/lib/hidflash/Makefile:        @echo "    hid-flash requires libusb-1.0, please install with:"
/home/mks/klipper/lib/hidflash/README:The source for the hid-flash program in this folder is a deriviative of the
/home/mks/klipper/lib/hidflash/README:The original source for hid-flash was written by Bruno Freitas, available
/home/mks/klipper/lib/hidflash/README:1) The "port" argument is now optional.  If not supplied hid-flash will not
/home/mks/klipper/lib/hidflash/README:2) When the serial port is specified, hid-flash will use Klipper's procedure
/home/mks/klipper/lib/hidflash/README:3) The hid-flash program now accepts a command from the bootloader that allows
/home/mks/klipper/lib/hidflash/README:   libusb-1.0 dependency for hid-flash.
/home/mks/klipper/lib/hidflash/main.c:* This version of hid-flash has been modified to work with Klipper.
/home/mks/klipper/lib/hidflash/main.c:    printf("Usage: hid-flash <bin_firmware_file> <comport (optional)> <delay (optional)>\n");
/home/mks/klipper/lib/.gitignore:hidflash/hid-flash
/home/mks/klipper/scripts/flash_usb.py:    args = ["lib/hidflash/hid-flash", binfile.html)
/home/mks/klipper/scripts/flash_usb.py:        raise error("Error running hid-flash")
/home/mks/klipper/scripts/flash_usb.py:# Flash via call to hid-flash
/home/mks/findfiles:find / -xdev -type f -print0 | xargs -0 grep "\<hid-flash\>"
Binary file /root/hid-flash matches
/var/lib/dpkg/info/makerbase-client.md5sums:ef3573cd08e43b74bbd22ab2dfe68f3b  root/hid-flash
/var/lib/dpkg/info/makerbase-client.list:/root/hid-flash
```
</details><!-- why is this visible ? -->

  * uart
    * **unknown binary, source code missing**
    * probably TFT [firmware uploader](https://github.com/QIDITECH/QIDI_PLUS3/blob/main/main.cpp#L95) for QIDI_PLUS3\
      (thanks to nubecoder for [investigation](https://github.com/torte71/InsideSovolKlipperScreen/issues/3#issue-2781797653))
    * references:
```
(tons of references found -> left out)
/var/lib/dpkg/info/makerbase-client.list:/root/uart
```

  * udp_server
    * **unknown binary, source code missing**
    * webserver that changes `/root/www/dev_info.txt`, seems related to QIDI printers\
      (thanks to nubecoder for [investigation](https://github.com/torte71/InsideSovolKlipperScreen/issues/3#issue-2781797653))
    * references:
```
/var/lib/dpkg/info/makerbase-client.md5sums:6f515dc45b55e81f496c64036318c75e  root/udp_server
/var/lib/dpkg/info/makerbase-client.list:/root/udp_server
Binary file /var/lib/selinux/default/active/policy.linked matches
Binary file /var/lib/selinux/default/active/policy.kern matches
```

----

## Services

### Sources of Makerbase services
  * The files below have been collected (and repackaged) from the original Sovol KlipperScreen images
  * The [MS1987/SOVOLMKDEB](https://github.com/MS1987/SOVOL_MKDEB) repository seem to be the source of the original packages\
    (thanks to nubecoder for [investigation](https://github.com/torte71/InsideSovolKlipperScreen/issues/3#issue-2781797653))

### makerbase-auto-fresh.service
  * **Installs system updates**
  * Files: [makerbase-auto-fresh-files](makerbase-auto-fresh-files.html)
  * Unofficial package: [makerbase-auto-fresh-service.deb](files/makerbase-auto-fresh-service.deb)
  * Details:
    * if existing: install `/root/system_deb/*.deb` and reboot
    * if existing: install `/root/bootsplash.armbian` and reboot
    * if USB drive found:
      * ensure running automounter (mounts to `./printer_data/gcodes/USB`)
      * move `armbian-update.deb` from automount to `/home/mks`, then install and reboot
  * Depends on makerbase-automount@.service
  * Might become useful once there is an unbricking-package like Sovol's armbian-update.deb

### makerbase-automount@.service
  * **Mounts all storage devices/partitions under /home/mks/printer_data/gcodes/USB/**
  * Files: [makerbase-automount-files](makerbase-automount-files.html)
  * Unofficial package: [makerbase-automount-service.deb](files/makerbase-automount-service.deb)
  * Useful for those who want to have USB-drives automatically mounted as gcode storage

### makerbase-beep.service
  * **Beeps if touchscreen is touched**
  * Files: [makerbase-beep-files](makerbase-beep-files.html)
  * Unofficial package: [makerbase-beep-service.deb](files/makerbase-beep-service.deb)
  * Details:
    * initializes GPIO#82 (beeper pin)
    * reads events from touchscreen (with vendor_product_id=\*1a86\*e5e3\*)
    * beeps if touch-button got pressed
  * Useful

### makerbase-byid.service
  * **Updates `serial:` from section `[mcu]` in `home/mks/printer_data/config/printer.cfg`**
  * Files: [makerbase-byid-files](makerbase-byid-files.html)
  * Unofficial package: [makerbase-byid-service.deb](files/makerbase-byid-service.deb)
  * Probably useless, the name of the serial connection doesn't change

### makerbase-net-mods.service
  * **copies `/boot/wpa_supplicant-wlan0.conf` (if existing) into `/etc/wpa_supplicant/`**
  * Files: [makerbase-net-mods-files](makerbase-net-mods-files.html)
  * Unofficial package: [makerbase-net-mods-service.deb ](files/makerbase-net-mods-service.deb )
  * Probably useless, you can configure wifi on the screen

### makerbase-soft-shutdown.service
  * **looks disabled**
  * does something with the "supper" capacitor
  * Files: [makerbase-soft-shutdown-files](makerbase-soft-shutdown-files.html)
  * Unofficial package: [makerbase-soft-shutdown-service.deb](files/makerbase-soft-shutdown-service.deb)
  * Unsure, if it is useful:  
    It writes "0" to gpio100 at boot time (whatever that does) and then syncs the filesystem every 2 seconds. The syncing might be of some use, if the device is not shut down before cutting the power.

### makerbase-timezone-monitor.service
  * **Fetches time via NTP every 3 seconds** (spamming syslog)
  * Update timezone to that from `/home/mks/target_timezone.txt`
  * Files: [makerbase-timezone-monitor-files](makerbase-timezone-monitor-files.html)
  * Unofficial package: [makerbase-timezone-monitor-service.deb](files/makerbase-timezone-monitor-service.deb)
  * requires `/home/mks/target_timezone.txt`
  * Probably useless, works fine without

### makerbase-wlan0.service
  * **configures wpa_supplicant**
  * Files: [makerbase-wlan0-files](makerbase-wlan0-files.html)
  * Unofficial package: [makerbase-wlan0-service.deb](files/makerbase-wlan0-service.deb)
  * Probably useless, works fine without

----

### power loss recovery (plr)
  * **resumes print after power failure**
  * ~~origin: https://github.com/The--Captain/plr-klipper~~
  * seems to be based on [YUMI_PLR](https://github.com/Yumi-Lab/YUMI_PLR)\
    (thanks to nubecoder for [investigation](https://github.com/torte71/InsideSovolKlipperScreen/issues/3#issue-2781797653))
  * Used files:
    * [~/printer_data/config/plr.cfg](files/plr.cfg)
    * [~/plr.sh](files/plr.sh)
    * [~/clear_plr.sh](files/clear_plr.sh)
  * Unofficial package: [plr-klipper.deb ](files/plr-klipper.deb )
  * Included in Sovol's default printer.cfg, thus it's recommended

----

## Reverting

### power loss recovery (plr)

  1. Make a backup of printer.cfg!
  1. Edit printer.cfg, find and remove the 3 paragraphs shown below.
  1. Test the new config: Do a normal print with normal end. And then cancel a print.
  1. If there are errors, revert to your backed-up printer.cfg
  1. If everything is fine, log in via ssh/putty and remove the unused files: "rm ~/plr.sh ~/clear_plr.sh ~/printer_data/config/plr.cfg"

#1: Somewhere at the beginning:
```
[include plr.cfg]
```

#2: At the start of "[gcode_macro CANCEL_PRINT]", after "gcode:":
```
    SAVE_VARIABLE VARIABLE=was_interrupted VALUE=False
    RUN_SHELL_COMMAND CMD=clear_plr
    clear_last_file
    G31
```

#3: Before the "SAVE_CONFIG" section:
```
[gcode_macro PRINT_START]
gcode:
    SAVE_VARIABLE VARIABLE=was_interrupted VALUE=True
[gcode_macro PRINT_END]
gcode:
    SAVE_VARIABLE VARIABLE=was_interrupted VALUE=False
    RUN_SHELL_COMMAND CMD=clear_plr
    clear_last_file
 
```

----
Back to [start](index.html)
