---
title: Backlight
layout: page
parent: Hardware
---
# Backlight
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Backlight switching (for screensaver)

By default, the screensaver does not turn off the backlight on this device.
But there are different approaches how that can be achieved:

**Option a) Direkt access via GPIOs**

- Advantages:
  - Works with XOrg and Wayland
  - No devicetree modification required
- Disadvantages:
  - Has to be implemented by the application
  - Requires direct access to GPIOs for current user

**Option b) Indirect access via backlight device driver**

- Advantages:
  - Works for all XOrg applications
  - Does not require direct GPIO access for current user
- Disadvantages:
  - Does not work with Wayland (unless you code your own screensaver)
  - Requires devicetree modification

## Option a) Direkt access via GPIOs

Backlight can be switched by writing either "0" or "1" to gpio101 (a.k.a. "gpiochip3/gpio5", see [GPIO-naming](gpio_naming.html)). For this to work, gpio101 a) needs to be writeable by the current user and b) must not be in use by the backlight device driver.

The KlipperScreen service is then responsible for switching backlight when it starts the screensaver:

- When starting/stopping the screensaver, KlipperScreen also switches `screen_on_devices` and `screen_off_devices` (provided they have been defined).

- The `screen_on_devices` and `screen_off_devices` refer to a power device, which has to be defined in Moonraker.conf and contains the gpio to be used.

### Supported image versions

This approach works for all image versions (including Sovol's original image).

### Installation

- Deinstall the [backlight-fix](#backlight-fix) (if you have installed it before)
- **Set GPIO access rights (add udev rule)**
  - Execute `sudo nano /etc/udev/rules.d/90-gpio.rules`
  - Add following line:\
    `SUBSYSTEM=="gpio", KERNEL=="gpiochip*", MODE="0660", GROUP="dialout"`
  - Use \<CTRL+X\>, "Y" and \<RETURN\> to save and exit
  - Reboot
- **Define Moonraker power device**
  - Edit Moonraker config: `nano ~/printer_data/config/moonraker.conf`
  - Add following lines:\
```
[power Backlight]
type: gpio
pin: gpiochip3/gpio5
initial_state: on
```
  - Use \<CTRL+X\>, "Y" and \<RETURN\> to save and exit
- **Define KlipperScreen "screen_on/off" devices**
  - For original Sovol image (with not-updated KlipperScreen):
    - Edit KlipperScreen config: `nano ~/KlipperScreen/KlipperScreen.conf`
  - For all other images:
    - Edit KlipperScreen config: `nano ~/printer_data/config/KlipperScreen.conf`
  - Add following lines:\
    (If there already is a `[main]` section, then only append the next two lines to that section.)\
```
[main]
screen_on_devices: Backlight
screen_off_devices: Backlight
```
  - Use \<CTRL+X\>, "Y" and \<RETURN\> to save and exit
- **Restart Moonraker and Klipperscreen services:**
  - Execute `sudo service moonraker restart`
  - Execute `sudo service KlipperScreen restart`
  - Or just reboot (esp. if you didn't reboot after adding the udev rule)

## Option b) Indirect access via backlight device driver

### Initialization bug

Due to a kernel bug, the backlight starts in OFF state (even though the devicetree tells it otherwise).

It gets switched on, when Xorg (KlipperScreen) starts and it also seems to start up in ON state when added as an overlay instead of embedding it directly into the devicetree.

Unless this bug is resolved, that setting will not be included in the images for the MKS-Klipad50.

*When running KlipperScreen, you will probably not notice that initialization problem, so it is safe to use the backlight modification.*

Sometimes the screen needs to be tapped twice to come up from sleep state.

### Backlight fix

There is a [backlight-fix](files/backlight-fix) script that installs/removes the required devicetree settings.

#### Supported image versions

The script supports the old buster version (original Sovol image)
and recent Armbian images for MKS-PI or MKS-Klipad50 (bookworm, trixie, noble, jammy).

#### Installation

To enable backlight switching:
- Revert the changes from [Direkt access via GPIOs](#a-direkt-access-via-gpios) (if you have implemented that before)
- Download the script: `wget https://torte71.github.io/InsideSovolKlipperScreen/files/backlight-fix`
- Install: `sudo bash backlight-fix install`
- Uninstall:  `sudo bash backlight-fix remove`
- Reboot is required: `sudo reboot`

