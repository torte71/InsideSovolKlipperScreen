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

That means, that the kernel and the whole system can now simply be updated without any hazzles from overwritten devicetree files.

## Download locations
- Custom [Images](https://github.com/torte71/armbian-mksklipad50) on GitHub
- Community Images on Armbian (coming soon)

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

## Tweaks, bells and whistles

### Customizing the status LEDs

The behaviour of the green and blue status LEDs can be set using the sysfs file system.

The settings for these LEDs can be found in following directories:
```
/sys/class/leds/firefly:blue:user/
/sys/class/leds/firefly:green:power/
```

To change them, you must either be "root" or you change their permissions to allow e.g. the user "mks" writing to it.
The easiest way is adding following commands to `/etc/rc.local`:
```
chown mks:mks /sys/class/leds/firefly\:blue\:user/\*
chown mks:mks /sys/class/leds/firefly\:green\:power/\*
```

After a reboot, the following commands will work for user "mks".

- Turn LED on/off:
  - Turn off: `echo "0" > /sys/class/leds/firefly:blue:user/brightness`
  - Turn on: `echo "1" > /sys/class/leds/firefly:blue:user/brightness`

- Reverse on/off:
  - Normal behaviour: `echo "0" > /sys/class/leds/firefly:blue:user/invert`
  - Inverted behaviour: `echo "1" > /sys/class/leds/firefly:blue:user/invert`

- Change trigger (what makes them blink):
  - Show possible triggers: `cat /sys/class/leds/firefly:blue:user/trigger`
    - Sample output: `none usb-gadget usb-host kbd-scrolllock kbd-numlock kbd-capslock kbd-kanalock kbd-shiftlock kbd-altgrlock kbd-ctrllock kbd-altlock kbd-shiftllock kbd-shiftrlock kbd-ctrlllock kbd-ctrlrlock disk-activity disk-read disk-write mtd nand-disk heartbeat cpu cpu0 cpu1 cpu2 cpu3 [activity] default-on panic usbport mmc2 mmc1 mmc0 rfkill-any rfkill-none rfkill0`
    - The option in \[brackets\] is currently selected ("activity" in this example)
  - Change trigger:
    - Choose a trigger name from that list and "echo" it to the "trigger" sysfs file.
    - Example: Display emmc activity: `echo mmc1 > /sys/class/leds/firefly:blue:user/trigger`

You might have guessed, that you can use "firefly:green:power" in these examples as well.

To use these commands without changing the access rights, you can use following syntax:
`echo activity |sudo tee /sys/class/leds/firefly:blue:user/trigger`

Note: In the original Sovol image, these LEDs have wrong names (but work identical):
- Blue LED: `firefly:yellow:user`
- Green LED: `firefly:blue:power`


### Enable unsupported devices (devicetree overlays)

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

