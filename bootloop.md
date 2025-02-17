---
title: Boot loops / Black screen ("unbricking")
layout: page
parent: Troubleshooting
---
# Boot loops / Black screen ("unbricking")
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Some causes for the looping boot animation
  * Damaged "saved_variables.cfg"
  * Other damaged configuration files (printer.cfg, moonraker.cfg, etc.)
  * KlipperScreen in a too recent version (depends on python-3.8, which is not available for Sovol's outdated armbian buster). See [klipperscreen:python-3.8](updating.html#klipperscreen--python-38) for a fix.

## Typical causes for the damaged files
  * No more space left on the filesystem
  * Powering off the KlipperScreen by the switch without shutting it down first
  * Incompatible or wrongly installed additional klipper macros

## Some causes for a black screen
  * Updating the system without having the kernel and dtb file locked  
     (That became unlikely after Armbian Buster got removed from online archives in spring 2024.)

## Fixes
  * Always make sure that there is enough space left on the filesystem first by removing old gcode files (and then reboot the device).
  * Clean up the `saved_variables.cfg` as shown below
  * If that did not help: Do a factory reset using Sovol's `armbian-update.deb`
  * If even that did not work: Do a full reflash of the eMMC using Sovol's `KLIPAD50_IMAGE`

## Cleaning up `saved_variables.cfg`
  * Open that file in the web frontend (found in the `machine` tab in mainsail or the configuration tab `{...}` in fluidd)
  * Replace the content of that file with the following lines, then save and reboot the device:
```
[Variables]
filepath = ''
last_file = ''
was_interrupted = False
```

## Factory reset using Sovol's `armbian-update.deb`
  * **This will revert all your changes to the config files** (like printer.cfg, etc.).  
     If the device can still be reached by the web frontend, you may want to back up these files first.
  * Download the `armbian-update.deb` for your device:
    * SV06: <https://drive.google.com/drive/folders/18LJ_qcjoFt0otg0_P0KJrgoEqEv43sg5>
    * SV06+: <https://drive.google.com/drive/folders/1vpKWQXOMGV58dYcx2wK9wJC0HJNqU8tg>
    * SV07: <https://drive.google.com/drive/u/1/folders/10OwQUHGtp0wLJ-Es8r0qcBh8Pv-v-0eZ>
    * SV07+: <https://drive.google.com/drive/u/1/folders/1C6pYe3R7gaXGrz8XPOCsynxWfd5OKpAX>
  * If the above links have changed, find them on Sovol's pages:
    * SV06 / SV06+: <https://www.sovol3d.com/collections/fdm-parts/products/sovol-klipper-screen-for-sv06-sv06-plus>  
     (scroll down to "Sovol SV06 Klipper Screen Firmware" or "Sovol SV06 Plus Klipper Screen Firmware")
    * SV07: <https://wiki.sovol3d.com/en/SV07> (look for "Firmware", e.g. "SV07 1.0.17 Latest Firmware (5th Oct 2023)")
    * SV07+: <https://wiki.sovol3d.com/en/SV07PLUS> (look for "Firmware", e.g. "SV07 Plus 1.0.8-07P Firmware (5th October 2023)")
  * Once you've downloaded the `armbian-update.deb`, copy it to main directory of an USB thumb drive. It's best to format it to FAT32 first.
  * Keep the name of that file *exactly* as it is, e.g. don't use capital letters.
  * Insert that USB drive into any of the KlipperScreen's USB ports, power up the device (if you haven't done already) and wait. The system will detect the update and install it.
  * If the update does not take place, try a different USB port or a different thumb drive.
  * The update process is also shown in this video: <https://www.youtube.com/watch?v=b2jUo1KnxZw&t=157s>

## Full reflash of the eMMC using Sovol's `KLIPAD50_IMAGE`
  * It is recommended to get an USB-eMMC adapter like [this one](https://www.aliexpress.us/item/3256805428404625.html?spm=a2g0o.store_pc_allProduct.8148356.1.7bca1ad70ZKzwN&pdp_npi=4%40dis%21USD%21US%20%246.99%21US%20%241.99%21%21%216.99%211.99%21%40212aa2ac17038484556595237e184f%2112000033755356288%21sh%21US%21240163459%21&gatewayAdapt=glo2usa).
     It allows you to flash the eMMC directly from your PC using software like e.g. [Balena Etcher](https://www.balena.io/etcher/)
    * Follow Sovol's guide on how to flash the eMMC card: <https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM>
  * It is also possible to flash the eMMC card without the eMMC adapter by booting from a thumb drive, but it is more complicated:
    * ThomasOlsson's guide using a single thumb drive: <https://github.com/TomasOlsson/BrickedSv07-Sv07Plus>
    * vasyl83's guide using two thumb drives: <https://github.com/vasyl83/SV07update>
    * You may also want to take a look on my guides how to [boot from external devices](booting.html) or [getting access](access.md) (both are quite technical)

