---
title: Hardware
layout: page
nav_order: 3
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

They require the same kernel patches as the MKS-PI/MKS-SKIPR boards, but their devicetree configuration is quite different. The amount of devicetree changes between these boards (and the lack of network connection at firstboot) speak for a new board definition instead of implementing them as a huge devicetree overlay for the MKS-PI platform.

The devicetree definitions have been reverse-engineered from the decompiled dtb of the original image on that board.

## Armbian images

Support for the MKS-Klipad50 board is now integrated in mainline Armbian.

That means, that the kernel and the whole system can now simply be updated without any hazzles from overwritten devicetree files.

### Download locations
- Custom [Images](https://github.com/torte71/armbian-mksklipad50) on GitHub
- Community Images on Armbian (soon)

### What works well
  - Summarized: Everything that worked with the original image.
  - HDMI-Display (hardwired, "Designware HDMI"): Runs at native 800x480x32.
  - Touchpanel (hardwired, "QinHeng Electronics USB2IIC_CTP_CONTROL", USB-ID 1a86:e5e3): Works as expected.
  - USB2/3/C (running ethernet adapters, webcams, storage, hubs, serial console)
  - External SPI: Tested OK in Klipper using attached ADXL345 sensor.
  - WiFi (rtl8723bs): Always in use, no flaws showed up.
  - Status-LEDs ("gpio-leds" via rk805 gpio-controller): Setting triggers, states, etc. via sysfs works correctly.
  - Internal I2C buses, MMC devices: Device would be "dead" without them working.

### Known issues and limitations
  - IRQ#33 / IRQ#40 "nobody cared"
    - Original image behaviour: Identical (IRQ#58 instead)
    - Either one of these IRQs cause an unhandled irq exception at some time after boot. When this happens, querying the RTC stops working.

  - RTC vs gmac2phy (ethernet@ff550000)
    - Original image behaviour: Worse
    - The "hwclock" command tends to time out ("hwclock: select() to /dev/rtc0 to wait for clock tick timed out").
      If gmac2phy is disabled (it has no physical connector), then "hwclock" always times out.
      If gmac2phy is enabled, then "hwclock" works until the unhandled IRQ#33/IRQ#40 happens.
      On the original image, "hwclock" always times out, even though gmac2phy is enabled in their configuration. So "we" are at least a bit better.

  - Power button
    - Original image behaviour: Indentical
    - There is a power button, which behaves like an ACPI-power-button (press 3 seconds to power off, press again to power up) and there is a rk805-powerkey device detected and set up as input device, but I could not get any events from it, neiter in the original image, nor in this version.

