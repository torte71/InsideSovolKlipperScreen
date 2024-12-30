---
title: Booting
layout: page
nav_order: 15
---
# Booting
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

There are different options for booting from an external device (useful e.g. to reflash the eMMC)

  * Boot the [same image](#boot-the-same-image-from-an-usb-stick) from an USB-stick
  * Boot image from USB-stick via [serial console](#boot-image-from-usb-stick-via-serial-console)
  * Boot from USB-stick with [unbootable eMMC](#boot-from-usb-stick-with-unbootable-emmc)

Troubleshooting
  * Only the two USB-2.0 ports can be used for booting:
    * One is the single port on the upper right side
    * The other is the port directly near the power plug (at the bottom left)
    * The port near the powerplug works very unreliable for me, but that may not be the case for you

## Boot the same image from an USB-stick

This is the easiest way, but does not always work.

If the image that you want to boot is the same as the one on the device, then you can simply insert the USB-stick and reboot.  
    
Afterwards, log in via SSH and check, if you have really booted from USB-stick:
```
mount|grep sda
```
If you have successfully booted from the USB-stick, the output will read
```
/dev/sda2 on / type ext4 (rw,noatime,errors=remount-ro,commit=1)
```

If the output reads
```
/dev/mmcblk1p2 on / type ext4 (rw,noatime,errors=remount-ro,commit=1)`
```
then you didn't have luck and need to try other ways.

Background info:
  * This is not an intended feature, but rather a bug/exploit
  * If the images are identical, the partitions will have identical UUIDs.
  * During boot, the initrd looks for this UUID to identify the partition to boot the rest of the system from.
  * When there are two identical UUIDs, the first one found will be used (or the last one? doesn't matter)
  * With some luck, the system partition from the USB-stick was booted (`/boot` will still be mounted from `/dev/mmcblk1p1`)


## Boot image from USB-stick via serial console

This way uses u-boot commands to boot from an USB-stick. It is a little tricky, but safe.

The bootloader ("u-boot") can be interrupted using keyboard input via a serial line.

The board has to be shut down, but still connected to power. In this state, the two visible LEDs at the top of the case are off, but there is another blue LED inside the case, which is on and can be seen through the air holes (there is also a red LED near the blue one, which is also shining, but hardly visible).

To get into this state
  - Have your device booted
  - Connect the USB-C port to your computer
  - Open a serial connection (see https://github.com/TomasOlsson/BrickedSv07-Sv07Plus)
  - Shut down the device
    - either by using the power-off button on the screen
    - or log in via ssh and execute `sudo poweroff`.

Now interrupt the bootloader:
  - Activate the window with the serial connection and **keep the spacebar pressed**
  - With the other hand, press the small "on" button on the side of the device (for about a second, until the device turns on)
  - After some lines, the console window will stop and show `Hit any key to stop autoboot:  0`
  - If you see the spaces arriving in the console, you can **now stop pressing the spacebar**

To boot from USB, enter `run bootcmd_usb0` (the word "run" really has to be typed there).



## Boot from USB-stick with unbootable eMMC

This is the way shown in https://github.com/TomasOlsson/BrickedSv07-Sv07Plus   
    
It is a little bit risky, as you have to brick your device before knowing if the USB-stick really boots up.


The board will automatically boot from USB when the internal eMMC is unbootable.  
    
(But the eMMC must still be present. When removed, no boot attempt happens at all)

To make the eMMC card unbootable:
  * Boot the device
  * Log in via a serial connection
  * Overwrite the bootsector of the eMMC: `sudo dd if=/dev/zero of=/dev/mmcblk1 bs=512 count=1`
  * Insert the USB-stick
  * Restart the device (either via command or the power plug)

The device will now try to boot from the USB-stick.

----
Back to [start](index.md)
