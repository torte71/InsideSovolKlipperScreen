---
title: Firmware
layout: page
nav_order: 3
---
# Firmware
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----


## Where to download
Klipper screen firmware location: (no permanent link given by Sovol)
  * browse to: <https://sovol3d.com>
  * menu: "3D Printer" -> "Sovol SV06 Plus"
  * scroll down to "Select addons"
  * select "Sovol Klipper Screen"
  * scroll down to "Sovol SV06 Plus Klipper Screen Firmware"  
    (currently points to <https://drive.google.com/drive/folders/1vpKWQXOMGV58dYcx2wK9wJC0HJNqU8tg?usp=sharing>)

## SD-card not accepted
  * Firmware.md file has to be renamed for each(!) update (\*1)
  * Use a card smaller than 32GB but bigger than 2GB (\*2)
  * Format only as "FAT32" (do NOT use "exFAT" or "NTFS")
  * Set the sector size to 4096
  * Have no other files or directories on that card

\*1: It only gets installed, if the filename differs from the one, which was used for the current installation.  
\*2: Smaller than 2GB does not support 4096byte sectors, larger than 32GB does not support FAT32. If your card is bigger, create a partition which is smaller than 32GB.

Some info about SD-cards taken from [here](https://forum.sovol3d.com/t/sv06-mainboard-brick-after-updating-sovol-firmware/862/68).

----
Back to [start](index.md)
