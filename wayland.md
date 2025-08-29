---
title: Wayland vs. XOrg
layout: page
parent: Configuring
nav_order: 7
---
# Wayland vs. XOrg
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

{: .note }
> This is experimental and has only been tested with Armbian Bookworm images.
>
> It does NOT work with Debian Trixie images.
>
> It has NOT been tested with the original Sovol image at all.

## Pros and Cons

Pros:
- Wayland consumes less CPU power

Cons:
- Not working with Debian Trixie (rotation)
- Wayland does not support DPMI blanking
- Wayland is less tested

## Setup

### Option 1: KIAUH

The simplest way is using KIAUH.

During KlipperScreen you will be asked wether to use XOrg (default) or Wayland.\
Just choose Wayland there.

If you have already set up KlipperScreen, you can deinstall it and then reinstall it using KIAUH

### Option 2: Manual setup

If you have already installed KlipperScreen with XOrg support, you can switch to Wayland manually.

{: .note }
> The next steps need to be done as root. Execute
>
````
sudo su
cd
```
>
> And when you are done, execute `exit` to switch back to the default user.

- **Install required packages:**\
    `apt install -y cage seatd xwayland`
- **Switch to udev touchscreen rotation**\
  (This supports both XOrg and Wayland, so it is more flexible)
  - **Remove "InputClass" section** from `/etc/X11/xorg.conf.d/01-armbian-defaults.conf`\
    (or comment it out)
{% raw  %}
```
# Default Armbian config

Section "Device"
    Identifier "default"
    Driver "fbdev"
    Option "Rotate" "CW"
EndSection

# now in /etc/udev/rules.d/99-calibration.rules
#Section "InputClass"
#    Identifier "libinput touchscreen catchall"
#    MatchIsTouchscreen "on"
#    MatchDevicePath "/dev/input/event*"
#    Driver "libinput"
#    Option "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
#EndSection
```
{% endraw  %}
  - **Create udev rule** for touchscreen rotation: `/etc/udev/rules.d/99-calibration.rules`
```
#Bus 004 Device 003: ID 1a86:e5e3 QinHeng Electronics USB2IIC_CTP_CONTROL
ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="e5e3", ENV{LIBINPUT_CALIBRATION_MATRIX}="0 1 0 -1 0 1 0 0 1"
```
- **Modify KlipperScreen service**: `/etc/systemd/system/KlipperScreen.service`
  - Replace the line
```
Environment="KS_XCLIENT=/home/mks/.KlipperScreen-env/bin/python /home/mks/KlipperScreen/screen.py" BACKEND=X
```
  - With this line
```
Environment="KS_XCLIENT=-rrr /home/mks/.KlipperScreen-env/bin/python /home/mks/KlipperScreen/screen.py" BACKEND=W
```
  - Don't overlook the `-rrr` and `BACKEND=` option ;)
- **Reload udev rules and restart KlipperScreen**
```
udevadm control --reload-rules && udevadm trigger
service KlipperScreen restart
```

{: .note }
> Debian Trixie comes with cage-0.2.0, which does NOT support screen rotation (see below).

**Reverting to XOrg:**

- Edit `/etc/systemd/system/KlipperScreen.service` and revert it to the first "Environment=" line
- Restart KlipperScreen: `service KlipperScreen restart`

----

Note about **cage 0.2.0**
- Option "-r" does not exist anymore (remove "-rrr" from above command)
- Incomplete recipe:
  - Use "wlr-randr" for rotation
    - Install: `apt install wlr-randr`
    - Execute: `wlr-randr --output HDMI-A-1 --transform 270`

Note about **screensaver**
- There is no real screensaver support yet
- Consider the [backlight-gpio](backlight.html#a-direkt-access-via-gpios) approach for KlipperScreen.
- Incomplete recipe: You may implement your own screensaver using "swayidle", e.g. if you use the [backlight-device](backlight.html#b-indirect-access-via-backlight-device-driver) approach.
  - Install: `sudo apt install swayidle`
  - Execute `sudo chown mks:mks /sys/class/backlight/backlight/bl_power`
  - Execute `swayidle timeout 300 'echo 4 > /sys/class/backlight/backlight/bl_power' resume 'echo 0 > /sys/class/backlight/backlight/bl_power'`\
    (This will turn off backlight after 300 seconds of inactivity by writing "4" to `bl_power` and on activity it will write "0" to `bl_power` to turn it back on.)

