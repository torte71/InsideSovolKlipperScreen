---
title: Armbian images
layout: page
parent: Custom firmware options
nav_order: 1
---
# Armbian images
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

Support for the MKS-Klipad50 board is now integrated in mainline Armbian.

That means, that the kernel (and related stuff) can now simply be updated just like any other package, without any hazzles from overwritten devicetree files and similar problems.

## Download options

- **Latest MKS-Klipad50 [images](https://www.armbian.com/mks-klipad50/) on Armbian**
- **Community [releases](https://github.com/armbian/community/releases/) on Armbian**\
  (Make sure to choose images with "Mksklipad50" in their name)

### Available image types
- Debian Minimal/IOT
  - Smallest images containing just a minimal set of installed packages
  - Require some work replacing networkd with NetworkManager (for installing KlipperScreen)

- Ubuntu Server
  - Comes with some more preinstalled packages compared to Minimal/IOT
  - Network setup (for installing KlipperScreen) is a bit easier, as NetworkManager is already installed and configured

- Ubuntu Desktop
  - These images don't really make sense on that device and won't be build in the future.

### Why not Debian/Server?
That's for maintainability reasons:
- Armbian automatic builds do not offer all possible combinations of distributions (Debian, Ubuntu) and package selections (Minimal, Server, Desktop) due to limited resources.
- Debian/Server is a combination currently not offered for Armbian automatic builds.
- Providing my own Debian/Server builds would require constant work keeping them up to date.
- The Ubuntu images contain just a small subset of the original Ubuntu setup:
  - All proprietary "Canonical" stuff has been removed in the Armbian Ubuntu images.
  - Basically it is a Debian image, just with some more recent packages.

## What works well
  - Summarized: Everything that worked with the original image.
  - HDMI-Display (hardwired, "Designware HDMI"): Runs at native 800x480x32.
  - Touchpanel (hardwired, "QinHeng Electronics USB2IIC_CTP_CONTROL", USB-ID 1a86:e5e3): Works as expected.
  - USB2/3/C (running ethernet adapters, webcams, storage, hubs, serial console)
  - External SPI: Tested OK in Klipper using attached ADXL345 sensor.
  - WiFi (rtl8723bs): Always in use, no flaws showed up.
  - Status-LEDs ("gpio-leds" via rk805 gpio-controller): Setting triggers, states, etc. via sysfs works correctly.
  - Internal I2C buses, MMC devices: Device would be "dead" without them working.

## Known issues and limitations
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

  - RTL8152-USB3-ethernet adapter on USB3-port
    - This specific usb-ethernet adapter tends to stop working in the usb3 port after some time.
      - Constant error messages: `xhci-hcd xhci-hcd.0.auto: WARN: HC couldn't access mem fast enough for slot 1 ep 6`
      - This does not happen when plugged into an USB-2 port.
      - Other devices on that USB-3 port seem not to be affected. (Needs more investigation)
      - After removing the usb-ethernet, the driver needs several seconds before it detects the removal.
        - Once the removal is detected and `usb usb5-port1: attempt power cycle` appears in dmesg output, the adapter seems to work OK after re-inserting it into the same usb3 port.
    - Similar issue: <https://forum.radxa.com/t/rtl8153-usb3-not-working/2888>

## Enable unsupported devices (devicetree overlays)

There are two devicetree overlays that enable some devices for experiments, but they are probably not useful for normal users.

To enable these overlays:
- Execute `sudo armbian-config`
- Select "System" --> "Kernel" --> "SY210 - Manage device tree overlays"
- Press SPACE to select/unselect:
  - `rk3328-mksklipad50-enable-rtc-end1`
    - Enables the "end1" network adapter (though there is no physical port for it).
    - A side-effect of enabling that adapter is that the RTC starts working a little bit better (until the first IRQ#33/#40 exception gets triggered).
  - `rk3328-mksklipad50-enable-v4l2`
    - Enables some video4linux devices (/dev/video[012] and /dev/media[01])
    - Maybe it is possible to use the hardware video encoder?

