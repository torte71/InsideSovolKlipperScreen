---
title: Sovolized Armbian Klipper Image v24.2
layout: page
parent: Rebuilding on Armbian v24.2
nav_order: 17
---
# Sovolized Armbian Klipper Image v24.2
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

{: .note }
> There is a [newer version](armbian-mainline-image.html) for mainline Armbian v25.2

## For SV06/SV06+/SV07/SV07+ KlipperScreen (Makerbase MKS KLIPAD50)

A ready-to-use replacement image for Sovol's KlipperScreen can be downloaded at:  
    
<https://drive.google.com/file/d/1xy5em404ZeeOhga0X9CXQ6KVAzr-tuLX/view?usp=sharing>
    
(Extract it using [7zip](https://www.7-zip.org/))

It is based on Maxims Medvedevs image for Makerbase boards and using a recent armbian-bookworm.
(Sovol's image based on armbian-buster is outdated, there are no packages available for it any longer. So you can't easily add any additional packages.)  
    
Maxims image: [Release 0.3.4-24.2.0-trunk; Armbian-unofficial_24.2.0-trunk_Mkspi_bookworm_current_6.6.17.img.xz](https://github.com/redrathnure/armbian-mkspi/releases)

## Flashing the printer board ("mcu")

Please note that the **printer itself ("mcu") needs to be updated as well** (not just the KlipperScreen), otherwise it will complain about an outdated klipper version on the mcu and not be able to print.
For convenience, there is a **ready compiled mcu_firmware.bin** in the image (which you can easily access directly after flashing, it's located in the root of the eMMC/USB-stick).

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


Instructions for updating the "mcu_firmware.bin" can be found in the following link (scroll down to "RENAME THE FILE", just before the photos of the printer).
  * <https://github.com/3DPrintDemon/How-to-Update-Sovol-Klipper-Screen-To-Latest-Klipper-SV06-and-SV07/tree/main#updating-the-host-mcu-rpi--mcu-firmware>


## Contents of the image

The image was created as described here: [rebuilding](rebuilding.html)  
    
  * [Maxims image](https://github.com/redrathnure/armbian-mkspi/releases) (Version 0.3.4-24.2.0-trunk; bookworm; current-6.6.17 kernel)
  * [Customized dtb](files/rk3328-roc-cc.dtb) for enabling wifi & spidev
  * Default Klipper install: KIAUH, Klipper (v0.12.0-131-gd9043345), Moonraker (v0.8.0-324-ga3e4dac5), Mainsail (v2.10.0), Fluidd (v1.29.0), KlipperScreen (v0.3.9-64-g1c9d82a), Crowsnest (v4.1.6-1-ge96cd46f), G-Code-Shell-Command
  * Numpy for input shaper (see [Vasyl's guide](https://github.com/vasyl83/SV07update#15-accelerometer-input-shaper))
  * Makerbase/Sovol [additions](sovol_mods#services): makerbase-beep-service, makerbase-automount-service, Powerloss recovery/plr-klipper
  * Sovol's original [printer.cfg for SV06](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/blob/main/klipper_configuration/SV06/printer.cfg)
  * Screen [rotation](screen#rotation) (portrait mode)
  * g-code-macro ["BEEP"](beeper) (needs to be activated in printer.cfg, as it is not part of Sovol's original file)
  * Packages and files of the Makerbase/Sovol additions can be found in "/root/sovolize/" for easy install/deinstall using dpkg.


## Settings you might want to change (or at least know)

### Login passwords

  * Password for user "root": `makerbase`
  * Password for user "mks": `makerbase`
  * Location/Timezone: Europe/Germany

### Timezone

To change the timezone, execute `sudo armbian-config` and select "Personal" and then "Timezone".

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

----
Back to [start](index.html)
