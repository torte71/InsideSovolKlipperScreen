---
title: Status LEDs
layout: page
parent: Configuring
nav_order: 5
---
# Status LEDs

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

