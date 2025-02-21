---
title: Sovolized Armbian-mainline Klipper Image v25.2 (MKS-KLIPAD50)
layout: page
parent: Rebuilding on Armbian-mainline v25.5 (MKS-KLIPAD50)
---
# Sovolized Armbian-mainline Klipper Image v25.2 (MKS-KLIPAD50)
## For SV06/SV06+/SV07/SV07+ KlipperScreen (Makerbase MKS KLIPAD50)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----
A ready-to-use replacement image for Sovol's KlipperScreen can be downloaded at:  

**<https://github.com/torte71/mksklipad50-klipper-images/releases/tag/v25.5.0-trunk.87-01>**

(Extract it using [7zip](https://www.7-zip.org/) - or use Etcher, it can directly write .img.xz files.)

It is based on a recent Armbian Bookworm for the MKS-Klipad50 (v25.5.0-trunk.87-bookworm-minimal):\
https://github.com/armbian/community/releases/download/25.5.0-trunk.87/Armbian_community_25.5.0-trunk.87_Mksklipad50_bookworm_current_6.12.15_minimal.img.xz

## Flashing the printer board ("mcu")

Please note that the **printer itself ("mcu") needs to be updated as well** (not just the KlipperScreen), otherwise it will complain about an outdated klipper version on the mcu and not be able to print.
For convenience, there is a **ready compiled klipper0120439.bin** in the image (which you can easily access directly after flashing, it's located in the root of the eMMC/USB-stick).

## Flashing the the image to eMMC card

If you have an eMMC adapter, you can use these guides to flash the image:
  * Complete backup and restore with eMMC adapter: <https://www.youtube.com/watch?v=PrC8zaVCHys>
  * Flash with eMMC adapter: <https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM>

If you don't have that adapter, you can follow these guides for flashing using USB-sticks:
  * Flash using one USB-stick: <https://github.com/TomasOlsson/BrickedSv07-Sv07Plus>
  * Flash using two USB-sticks(\*): <https://github.com/vasyl83/SV07update>

(\*) Vasyl's version allows creating a full backup before overwriting the original eMMC:
Just follow its step to point 6 "Flashing the image onto EMMC" and switch the source ("if=") and destination ("of="),
so it reads `dd of=backup.img if=/dev/mmcblk1 status=progress`.

Instructions for updating the "klipper0120439.bin" can be found on the [Updating Klipper](updating_klipper.html) page.

## Contents of the image

The image was created as described here: [Rebuilding on Armbian-mainline v25.5 (MKS-KLIPAD50)](rebuilding.html)

Contents of the image:
  * [MKS-Klipad50 image](https://github.com/armbian/community/releases/) (Armbian_community_25.5.0-trunk.87_Mksklipad50_bookworm_current_6.12.15_minimal.img.xz)
  * Default Klipper install: KIAUH, Klipper (v0.12.0-439-g1fc6d214), Moonraker (v0.9.3-59-g62051108), Mainsail (v2.13.2), Fluidd (v1.32.3), KlipperScreen (v0.4.5-50-ge71fe755), Crowsnest (v4.1.11-1-g87669ccd), G-Code-Shell-Command
  * Numpy for input shaper (see [Vasyl's guide](https://github.com/vasyl83/SV07update#15-accelerometer-input-shaper))
  * Makerbase/Sovol [additions](sovol_mods#services): makerbase-beep-service, makerbase-automount-service, makerbase-soft-shutdown-service, Powerloss recovery/plr-klipper
  * Sovol's [printer.cfg for SV06](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/blob/main/klipper_configuration/SV06/printer.cfg) with following changes:
    * Removed deprecated option "accel_to_decel" to avoid warning
    * Included "BEEP" gcode and shell command
  * Screen [rotation](screen#rotation) (portrait mode)
  * g-code-macro ["BEEP"](beeper) (already added to printer.cfg)
  * Packages and files of the Makerbase/Sovol additions can be found in "/root/sovolize" for easy install/deinstall using dpkg.  
    The sources for these packages can be found in "/root/sovolize/sources/"

## Settings you might want to change (or at least know)

### Login passwords

  * Password for user "root": `makerbase`
  * Password for user "mks": `makerbase`
  * Location/Timezone: UTC

### Timezone

To change the timezone, execute `sudo armbian-config` and select "Personal" and then "Timezone" (or use `sudo dpkg-reconfigure tzdata`).

### Expand filesystem size

If you flash the ready image to an eMMC card bigger than 8GB, it will still only use the first 8GB of that card, the rest is unused.

To expand the filesystem that it uses the full size of the eMMC card:
  - Log into the device using ssh/putty
  - Execute `sudo /usr/lib/armbian/armbian-resize-filesystem`

### Language

The language has to be changed in KlipperScreen, Mainsail and Fluidd separately.

----

Thanks to all who helped testing, bug chasing and documenting.
Special thanks to Vasyl Gontar for his support and of course to Maxim Medvedev for his work re-creating the build-system for the Makerbase boards.
