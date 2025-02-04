---
title: Updating Klipper
layout: page
nav_order: 4
---
# Updating Klipper
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Recompiling Klipper
- First [log in](access.html#ssh-putty) to the device using ssh or putty.
- You need to recompile and install klipper *twice*.  
  Once for the virtual mcu ("mcu-rpi") on the KlipperScreen, and another time for the printer-board ("mcu"), which needs to be flashed via SD-card after that.
- **Compiling klipper for "mcu rpi"** (virtual mcu of the Klipper screen):
```
cd klipper
make menuconfig
```
  - Select "Micro-controller Architecture" and set to "Linux process".
```
make clean ; make ; sudo make flash
```

- **Compiling klipper for "mcu"** (the printer board):
```
cd klipper
make menuconfig
```
  - Change following settings
    * Micro-controller Architecture: STMicroelectronics STM32
    * Processor model: STM32F103
    * Bootloader offset: 28KiB bootloader
    * Communication interface: Serial (on USART1 PA10/PA9)
```
  # make clean ; make
```
  - Copy "out/klipper.bin" to SD-card and rename it (must end in ".bin").  
    !!! Use a different name than that from prior updates (e.g. add some random numbers) !!!  
    (The printer remembers the filename that was used for flashing and won't use it again.)
    - The printer is very picky about the format of the SD-card, make sure to format it with *exactly* these settings:
      - Card size: Smaller than 32GB, but bigger than 2GB (you can create a smaller partition on bigger cards)
      - Filesystem: FAT32 (FAT12/FAT16 also works). *Don't use exFAT or NTFS or anything other!*
      - Sector size: *Must* be set to 4096 (bytes per sector)
      - Better don't have any other files or directories on that card.


## SD-card not accepted
  * Firmware.bin file has to be renamed for each(!) update (\*1)
  * Use a card smaller than 32GB but bigger than 2GB (\*2)
  * Format only as "FAT32" (do NOT use "exFAT" or "NTFS")
  * Set the sector size to 4096
  * Have no other files or directories on that card

\*1: It only gets installed, if the filename differs from the one, which was used for the current installation.  
\*2: Smaller than 2GB does not support 4096byte sectors, larger than 32GB does not support FAT32. If your card is bigger, create a partition which is smaller than 32GB.

Some info about SD-cards taken from [here](https://forum.sovol3d.com/t/sv06-mainboard-brick-after-updating-sovol-firmware/862/68).

