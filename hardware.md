---
title: Hardware
layout: page
nav_order: 2
---
# Hardware
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## MKS-Klipad50

These single board computers are built by Makerbase and sold as Sovol's "KlipperScreen", an addon  for their SV06/SV07 3D-printers that contains a preinstalled Klipper system. The boards are not sold separately and there is absolutely no information about them on either the Makerbase web site or their github repository. In well-known Makerbase tradition, they don't offer any support or information (at least not to end-users).

The boards come with a hard-wired 5-inch HDMI-LCD display and touchpanel (via internal USB), external USB-2/3/C ports, an external SPI port (mainly for the included adxl345-spi acceleration sensor), two external LEDs and 802.11b/g Wifi (2.4GHz, 54MB/s max).

There are three revisions of the board (all are supported by the new Armbian images):
- 1.0 
  - Old WiFi chip
- 1.1
  - Old WiFi chip
  - Additional fan connector
- 1.2
  - New WiFi chip
  - Additional fan connector

They require the same kernel patches as the MKS-PI/MKS-SKIPR boards, but their devicetree configuration is quite different.

The devicetree definitions have been reverse-engineered from the decompiled dtb of the original image on that board.

The [MKS-Klipad50](https://www.armbian.com/mks-klipad50) changes are now integrated into mainline Armbian.

See [Armbian images](armbian_images.html) for details how this board is supported.

