---
title: Sovolized Armbian-mainline Klipper Image v25.2 (MKS-PI)
layout: page
nav_order: 1
parent: Rebuilding on Armbian-mainline v25.2 (MKS-PI)
---
# Sovolized Armbian-mainline Klipper Image v25.2 (MKS-PI)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## For SV06/SV06+/SV07/SV07+ KlipperScreen (Makerbase MKS KLIPAD50)

A ready-to-use replacement image for Sovol's KlipperScreen can be downloaded at:  

<https://github.com/torte71/mksklipad50-klipper-images/releases/tag/v25.2.0.05>

(Extract it using [7zip](https://www.7-zip.org/) - or use balena etcher, it can directly write .img.xz images.)

It is based on Maxims Medvedevs image for Makerbase boards and using a recent armbian-bookworm.
(Sovol's image based on armbian-buster is outdated, there are no packages available for it any longer. So you can't easily add any additional packages.)

Maxims image: [1.0.1-25.2.0-trunk; Armbian-unofficial_25.02.0-trunk_Mkspi_bookworm_current_6.12.8.img.xz](https://github.com/redrathnure/armbian-mkspi/releases/download/mkspi%2F1.0.1-25.2.0-trunk/Armbian-unofficial_25.02.0-trunk_Mkspi_bookworm_current_6.12.8.img.xz)

## Flashing the printer board ("mcu")

Please note that the **printer itself ("mcu") needs to be updated as well** (not just the KlipperScreen), otherwise it will complain about an outdated klipper version on the mcu and not be able to print.
For convenience, there is a **ready compiled klipper0120410.bin** in the image (which you can easily access directly after flashing, it's located in the root of the eMMC/USB-stick).

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


~~Instructions for updating the "klipper0120410.bin" can be found in the following link (scroll down to "RENAME THE FILE", just before the photos of the printer).~~
  * ~~<https://github.com/3DPrintDemon/How-to-Update-Sovol-Klipper-Screen-To-Latest-Klipper-SV06-and-SV07/tree/main#updating-the-host-mcu-rpi--mcu-firmware>~~

Instructions for updating the "klipper0120410.bin" can be found on the [Updating Klipper](updating_klipper.html) page.


## Contents of the image

The image was created as described here: [Rebuilding on Armbian-mainline v25.2 (MKS-PI)](armbian-mkspi-mainline-setup-v25-2.html)

Contents of the image:
  * [Maxims image](https://github.com/redrathnure/armbian-mkspi/releases) (1.0.1-25.2.0-trunk; Armbian-unofficial_25.02.0-trunk_Mkspi_bookworm_current_6.12.8.img.xz)
  * [Customized dtb](files/rk3328-mkspi.dtb) for enabling wifi & spidev
  * Default Klipper install: KIAUH, Klipper (v0.12.0-410-gcf3b0475), Moonraker (v0.9.3-4-ga4604e33), Mainsail (v2.13.2), Fluidd (v1.31.4), KlipperScreen (v0.4.5-40-g7ed39038), Crowsnest (v4.1.10-1-gdd390b60), G-Code-Shell-Command
  * Numpy for input shaper (see [Vasyl's guide](https://github.com/vasyl83/SV07update#15-accelerometer-input-shaper))
  * Makerbase/Sovol [additions](sovol_mods#services): makerbase-beep-service, makerbase-automount-service, makerbase-soft-shutdown-service, Powerloss recovery/plr-klipper
  * Sovol's [printer.cfg for SV06](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/blob/main/klipper_configuration/SV06/printer.cfg) with following changes:
    * Removed deprecated option "accel_to_decel" to avoid warning
    * Included "BEEP" gcode and shell command
  * Screen [rotation](screen#rotation) (portrait mode)
  * g-code-macro ["BEEP"](beeper) (already added to printer.cfg)
  * [Klipad50-dtb-fix](files/klipad50-dtb-fix.deb) (restores DTB file whenever a dtb-package install/removal is detected)
  * Packages and files of the Makerbase/Sovol additions can be found in "/root/" for easy install/deinstall using dpkg.  
    The sources for these packages can be found in "/root/sources/"

## Settings you might want to change (or at least know)

### Login passwords

  * Password for user "root": `makerbase`
  * Password for user "mks": `makerbase`
  * Location/Timezone: Europe/Germany

### Timezone

To change the timezone, execute `sudo armbian-config` and select "Personal" and then "Timezone" (or use `tzselect`).

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
