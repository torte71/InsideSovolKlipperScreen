---
title: Status LEDs
layout: page
parent: Configuring
nav_order: 5
---
# Status LEDs
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Customizing the status LEDs

The behaviour of the green and blue status LEDs can be set using the sysfs file system.

The settings for these LEDs can be found in following directories:
```
/sys/class/leds/firefly:blue:user/
/sys/class/leds/firefly:green:power/
```

To change them, you must either be "root" or you change their permissions to allow e.g. the user "mks" writing to it.
The easiest way is adding following commands to `/etc/rc.local`:
```
chown mks:mks /sys/class/leds/firefly:blue:user/*
chown mks:mks /sys/class/leds/firefly:green:power/*
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

### Additional trigger kernel modules

More triggers are available through kernel modules

- [ledtrig-backlight](https://www.kernel.org/doc/Documentation/devicetree/bindings/leds/backlight/gpio-backlight.yaml): Turns on/off when the screen is blanked/unblanked
- [ledtrig-pattern](https://www.kernel.org/doc/Documentation/devicetree/bindings/leds/leds-trigger-pattern.txt): Customizable blinking pattern, [ABI](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-led-trigger-pattern)
- [ledtrig-tty](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-led-trigger-tty): Trigger by TTY activity
- [ledtrig-gpio](https://www.kernel.org/doc/Documentation/devicetree/bindings/leds/common.yaml): Default triggers as decribed above
- [ledtrig-transient](https://www.kernel.org/doc/Documentation/leds/ledtrig-transient.txt)
- [ledtrig-oneshot](https://docs.kernel.org/leds/ledtrig-oneshot.html), [ABI](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-led-trigger-oneshot)
- ledtrig-timer
- [ledtrig-camera](https://www.kernelconfig.io/config_leds_trigger_camera) same as [led-flash](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-led-flash)?
- [ledtrig-netdev](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-led-trigger-netdev): Trigger by network activity

#### Example for ledtrig-netdev: Blink on WiFi activity

- Become root: `sudo su`
- Load kernel module: `modprobe ledtrig-netdev`
- Change into led's sysfs directory: `cd /sys/class/leds/firefly:blue:user`
- Set "trigger" to "netdev": `echo netdev > trigger`
- Select "wlan0" as trigger source: `echo wlan0 > device_name`
- Blink on RX and TX activity: `echo 1 > rx ; echo 1 > tx`
- Log out from "root" account: `exit`

Note: Options like "device_name", "rx", "tx" and the "netdev" trigger are only available after loading the netdev kernel module.

## Making the changes permanent

In recent Armbian versions, the default LED properties like "trigger", "brightness" and "invert" are automatically preserved between reboots.

When using custom triggers, it may be necessary to set their properties manually. You can do this e.g. by adding the required commands to `/etc/rc.local` (before the "exit 0" line, but after the "#" comment lines).

If you need additional kernel modules for custom triggers, you can add them to `/etc/modules` to get them automatically loaded at boot.

