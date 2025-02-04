---
title: Rebuilding on Armbian v24.2
layout: page
nav_order: 16
parent: Custom firmware archive
has_toc: false
---
# Rebuilding on Armbian v24.2
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

{: .note }
> There is a [newer version](armbian-mainline-setup.html) for mainline Armbian v25.2

Sovol's KlipperScreen is running on debian buster, which is outdated now, meaning you can no longer update system packages like ssh, etc.

The default armbian kernels do not work, e.g. the screen will stay black (no /dev/spidev*.* gets created).

There are recent images provided by Maxim Medvedev (redrathnure) on github, which can be used as a base:  
    
<https://github.com/redrathnure/armbian-mkspi>
    
These images do not support the KLIPAD50's internal wifi out of the box, so you would either have to replace a devicetree file (see bottom of the page) or use external USB-wifi(\*) or USB-ethernet adapters. But the screen is working and spidev is available. It's spidev0.2 instead of spidev0.0, so adjust your printer.cfg accordingly.  
    
(\*) These adapters may require additional firmwares. You can try to install them with `sudo apt update ; sudo apt install firmware-misc-nonfree` if yours is not detected automatically. On the other hand, this specific firmware package can break the internal wifi, even with the replaced dtb file.

Steps to set up:

## Base system

  - Select and download an image from <https://github.com/redrathnure/armbian-mkspi/releases>
    * if unsure, use `Armbian-unofficial_24.2.0-trunk_Mkspi_bookworm_current_6.6.17.img.xz`
    * extract the image (e.g. using 7zip or "xz -d", result should end in ".img" and be ~2.5GB in size)
    * flash the image to the eMMC card
      * if you have an eMMC USB-Adapter: <https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM>
      * if you DONT have an eMMC USB-Adapter: <https://github.com/TomasOlsson/BrickedSv07-Sv07Plus>
  - Reboot the device and connect a keyboard (or use an USB-cable for a serial connection)
  - Create root password
    * freely choose your own
  - Choose default system command shell
    * if unsure, choose "1" (bash)
  - Please provide a username
    * use "mks" if you want to stay compatible with makerbase services
  - Create user (mks) password
    * freely choose your own
  - Set user language based on your location?
    * if unsure, choose "Y"
    * otherwise, choose the setting according to your location/needs

## Klipper
  - Log into device using ssh, putty or serial connection
  - cd into home dir: ```cd```
  - install KIAUH: ```git clone https://github.com/dw-0/kiauh```
  - start KIAUH: ```cd kiauh ; ./kiauh.sh```
  - install klipper components (that's mostly pressing "1" or ENTER):
  - choose "Install" (1)
  - enter your password
  - choose "Klipper" (1)
    - choose "Python 3.x" (1)
    - choose number of instances (1)
    - wait for install to finish
  - choose "Moonraker" (2)
    - confirm with "Y" or ENTER
    - wait for install to finish
  - choose "Mainsail" (3)
    - when asked "Download recommended macros": confirm with "Y" or ENTER
    - wait for install to finish
  - choose "Fluidd" (4)
    - when asked "Please enter a new Port": enter "81"
    - when asked "Download recommended macros": confirm with "Y" or ENTER
    - wait for install to finish
  - choose "KlipperScreen" (5)
    - wait for install to finish (will take quite a while)
    - when asked "Install as a service?": confirm with "Y" or ENTER
  - choose "Crowsnest" (12)
    - wait for install to finish
    - when asked "Do you want to add 'update manager'": confirm with "Y" or ENTER
    - when asked "Reboot NOW? [y/N]": answer "N" or ENTER
  - choose "Back" (B)
  - choose "Advanced" (4)
    - choose "G-Code Shell Command" (8)
    - when asked "Do you want to continue?": confirm with "Y" or ENTER
    - when asked "Create an example shell command?": confirm with "Y" or ENTER
  - choose "Quit" (Q)
  - Set up secondary mcu: (see <https://www.klipper3d.org/RPi_microcontroller.html>) ```cd ~/klipper ; make menuconfig```
    - select "Micro-controller Architecture" (press ENTER)
    - select "Linux process" (press ENTER)
    - press "Q" and "Y" to quit and save
    - ```sudo make flash```
    - ```sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/```
    - ```sudo systemctl enable klipper-mcu.service```
    - ```sudo service klipper restart```
  - Fix screen rotation: ```sudo nano /etc/X11/xorg.conf.d/01-armbian-defaults.conf```
    - copy this text:
```
Section "Device"
        Identifier "default"
        Driver "fbdev"
        Option "Rotate" "CW"
EndSection
Section "InputClass"
        Identifier "libinput touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
EndSection
```
    - press \<CTRL-X\> to quit
    - press "Y" to save
    - press ENTER to confirm filename
    - restart KlipperScreen:```sudo service KlipperScreen restart```
  - Freeze the kernel
    - `sudo armbian-config`
    - select "System"
    - select "Freeze"

Now you should have a working (and recent) klipper installation on the Sovol KlipperScreen.

Copy your old printer.cfg - or take one of Sovol's files for your device: <https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration>

You will probably have to change "spidev0.0" to "spidev0.2" inside your "printer.cfg"   
    
(unless you've installed the wifi-enabled dtb below - in that case, it will be spidev0.0 again).

## Numpy

Numpy is required for input shaping, so it's a good idea to install it right now.  
(Thanks to Vasyl Gontar for this hint)
```
sudo apt-get update
sudo apt-get install python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
~/klippy-env/bin/pip install -v numpy
```

## Sovol mods

Modifications from Sovol useful for this image:  
    
(See [sovol_mods](sovol_mods.html) for details about the packages)

  * Beeps when pressing touchscreen
    * Download: [makerbase-beep-service.deb](files/makerbase-beep-service.deb)
    * To install:
      * Upload the *.deb to your device, e.g. using the web-frontend: Navigate to "G-CODE-FILES", then use the upload button (the one with the up-arrow). Or use scp, winscp or whatever you like.
      * Log into the device (ssh/putty/serial)
      * `sudo dpkg -i printer_data/gcodes/makerbase-beep-service.deb`
      * (change the path, if you've uploaded to a different location)
      * fix access rights to gpio82:
        * `sudo nano /etc/rc.local`
        * add following lines (before the `exit 0` line)
        * `chgrp mks /sys/class/gpio/gpio82/value`
        * `chmod g+w /sys/class/gpio/gpio82/value`
    * To uninstall:
      * `sudo dpkg -r makerbase-beep-service`

  * Automounting USB-drive
    * Download: [makerbase-automount-service.deb](files/makerbase-automount-service.deb)
    * Install/uninstall with `dpkg -i`/`dpkg -r` as shown above

  * Powerloss recovery (plr)
    * Unofficial package: [plr-klipper.deb](files/plr-klipper.deb)
    * Install/uninstall with `dpkg -i`/`dpkg -r` as shown above
    * Sovol's [printer.cfg](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration) makes use of `plr`, so it's recommended to either install this package, or remove these entries as shown [here](sovol_mods.html#reverting)

  * Splash screen
    * Afaik it's not possible to directly use Sovols original boot animation, as it is in a different format (old kernel based vs. actual plymouth). The file resides in `/usr/lib/firmware/bootsplash.armbian` and is ~250MB big. I haven't found a way to decompile it into separate pictures - if someone does, it will probably be possible to "cook" a plymouth style boot animation from it.
    * Enable plymouth splash screen:
      * Become root: `sudo su` (enter password when asked)
      * Edit `/boot/armbianEnv.txt` and change it to `bootlogo=true`
      * List available themes: `plymouth-set-default-theme -l`
      * Select a theme (e.g. "solar"): `plymouth-set-default-theme solar ; update-initramfs -u`
      * Restart the system: `reboot`
      * Themes are defined in `/usr/share/plymouth/themes/`


## Internal wifi + spidev

Replacing the dtb from the `redrathnure` image with Sovol's version of `rk3328-roc-cc.dtb` enables the internal wifi of the KLIPAD50 board, but does not create the spi device.
With the following change, `/dev/spidev0.0` will be created as well.

```
--- rk3328-roc-cc-org.dts	Sat Mar 09 16:36:40 2024
+++ rk3328-roc-cc-new.dts	Sat Mar 09 17:33:57 2024
@@ -860,7 +860,7 @@

 		spi_for_cs2@0 {
 			reg = <0x00>;
-			compatible = "rockchip,spi_test_bus1_cs2";
+			compatible = "armbian,spi-dev";
 			pinctrl-names = "default";
 			pinctrl-0 = <0x35>;
 			spi-max-frequency = <0x4c4b40>;
```

Source of Sovol's rk3328-roc-cc.dtb from 5.16.20 kernel [rk3328-roc-cc_dts](rk3328-roc-cc_dts.html)

Successfully tested with these [images](https://github.com/redrathnure/armbian-mkspi/releases):  
    
0.3.2-24.2.0-trunk: Armbian-unofficial_24.2.0-trunk_Mkspi_bookworm_current_6.1.76.img.xz   
    
0.3.4-24.2.0-trunk: Armbian-unofficial_24.2.0-trunk_Mkspi_bookworm_current_6.6.17.img.xz   
    
0.3.4-24.2.0-trunk: Armbian-unofficial_24.2.0-trunk_Mkspi_bookworm_edge_6.7.5.img.xz   
    

Additional notes:
  * I had some wifi-performance issues with 6.7.5, not sure if that was just by chance.
  * The wlan0 device did not show up when "firmware-misc-nonfree" was installed. Reverting to `armbian-firmware` fixed this.
  * To edit the dtb file on your own, use
    * `dtc -I dtb -O dts -o rk3328-roc-cc.dts rk3328-roc-cc.dtb` to decompile it to source form and
    * `dtc -I dts -O dtb -o rk3328-roc-cc.dtb rk3328-roc-cc.dts` to compile it back to binary form
  * The dtb files reside in the fat32 partition, you can easily replace them directly after writing the USB-stick or eMMC. So on the first boot you will automatically be asked to configure wifi. If you set it up using an USB-keyboard instead of a serial line, keep in mind that it uses US-keylayout when entering the passwords.

Here is a compiled version of the devicetree file: [rk3328-roc-cc.dtb](files/rk3328-roc-cc.dtb)

Download and replace `/boot/dtb/rockchip/rk3328-roc-cc.dtb` with this version and reboot.


## Crowsnest / camera streaming
  * The camera device will probably change after the update. Use `v4l2-ctl --list-devices` to check the available devices and change `crowsnest.conf` accordingly. (My camera now uses `/dev/video3`)
  * crowsnest may have problems initializing the camera after reboot. Workarounds:
    * Manually restart crowsnest service (works reliably, but sucks)
    * Add a pause to crowsnest initialization, as described in <https://github.com/mainsail-crew/crowsnest/issues/117#issuecomment-1806943132>
      * Adding a pause made the startup more reliably, but still not always (tested 5 and 10 seconds)
        * `CROWSNEST_ARGS="-c /home/mks/printer_data/config/crowsnest.conf -s 10"`
      * Make sure there aren't any backup copies of `~/printer_data/systemd/crowsnest.env`, as they might override the new setting.

----
Back to [start](index.html)

