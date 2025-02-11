---
title: Rebuilding on Armbian-mainline v25.2 (MKS-PI)
layout: page
parent: Custom firmware archive
//nav_order: 18
has_toc: false
---
# Rebuilding on Armbian-mainline v25.2 (MKS-PI)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

Since December 2024, the Makerbase kernel patches from Maxim Medvedev (redrathnure) have been included into mainline Armbian.
That makes it possible to keep the kernel up-to-date (and probably even upgrading the distribution).

It is still required to replace the DTB file with a special one tailored for the Klipad50, but that may change in the future.  
For now I have added a dpkg hook that simply replaces the DTB file, whenever a dtb-package install/remove has been detected
(the DTB file [rk3328-mkspi.dtb](files/rk3328-mkspi.dtb) is exactly the same as the prior [rk3328-roc-cc.dtb](rk3328-roc-cc_dts.html), it is just renamed).

## Different image options

You have the choice between the [community-builds](https://github.com/armbian/community/releases) and [Maxim's images](https://github.com/redrathnure/armbian-mkspi/releases).

### Maxims image
- Comes with more preinstalled packages (e.g. NetworkManager, aptitude, mc, vim, ...)
- Allows WiFi setup right after boot (if you replaced the DTB file beforehand)

### Community image
- Comes with just a minimal set of preinstalled packages
- Requires additional steps to get NetworkManager play together with networkd
- WiFi setup directly after boot is not working
- Requires at least 25.2.0-trunk.195 to support MKSPI boards (select one with "Mkspi" in the name)

## Steps to create a "sovolish" Klipper installation based on these images:

### Downloading and flashing the image
- Choose an image file from the above links. I recommend Maxim's images, as they are easier to set up.  
  - Images used for testing:
    - Maxim's (recommended): [1.0.1-25.2.0-trunk](https://github.com/redrathnure/armbian-mkspi/releases/download/mkspi%2F1.0.1-25.2.0-trunk/Armbian-unofficial_25.02.0-trunk_Mkspi_bookworm_current_6.12.8.img.xz)
    - Community (for the thrills): [25.2.0-trunk.293](https://github.com/armbian/community/releases/download/25.2.0-trunk.293/Armbian_community_25.2.0-trunk.293_Mkspi_bookworm_current_6.12.8_minimal.img.xz)
- Extract the image (e.g. using [7zip](https://www.7-zip.org/)).
- Write the extracted .img file to the eMMC card (e.g. using [Balena Etcher](https://www.balena.io/etcher/)).

### Replacing rk3328-mkspi.dtb for WiFi
- Don't remove the eMMC card from the PC yet.
- Use the Explorer to navigate to the "/boot/rockchip/" folder of the eMMC card
- Replace `/boot/rockchip/rk3328-mkspi.dtb` with this [rk3328-mkspi.dtb](files/rk3328-mkspi.dtb) to get WiFi access directly after booting

### Accessing the screen
- You can either use a serial connection (recommended) or work directly on the screen
  - Option 1) Serial access:
    - Power up the device without the eMMC inserted
    - Keep the power button pressed for some seconds until the device goes into soft-off state (which has serial access enabled)
    - Open the devicemanager to see, which COM-ports are already on your system
    - Connect the USB-C-port (on the bottom right of the device) with your PC
    - Look into the devicemanager again, a new COM-port should have been created
    - Use a terminal program (e.g. Putty) to connect to this port  
      Settings:
      - Speed (Baud rate): 1500000 (that's 5 zeroes after the "15")
      - Data bits: 8
      - Stop bits: 1
      - Parity: None
      - Flow control: None
  - Option 2) Direct access:
    - Plug an USB-keyboard into any of the device's USB ports
    - Disadvantages:
      - Very small
      - Keyboard uses US-Layout
      - Last row on screen is barely visible (use `clear` to clear the display and move the cursor to top)

### Initial setup
- Press the power button to boot the device
- Answer the account setup questions:
  - Enter root password (e.g. "makerbase"), repeat once more
  - Maxim's image will ask for the "default system command shell"
    - Choose "1" for "bash" (unless you know better)
  - Enter username (e.g. "mks")
  - Enter user password (e.g. "makerbase"), repeat once more
  - Enter real name (e.g. "Mks")

### Network setup
The next steps are slightly different, depending if you use a) an USB-Ethernet adapter, b) WiFi with Maxim's image or c) WiFi with a community image
- a) USB-Ethernet adapter:
  - Will continue right at "Set user language based on your location?"
- b) Wifi with Maxim's image:
  - Answer "y" to "connect via wireless?" (or just press ENTER)
  - Select your access point in the dialog
  - Enter your WiFi password
- a) and b)
  - When asked "Set user language based on your location?":
    - Choose what you want. I prefer "no", because untranslated error-messages give better online search results
  - When asked for generating locales:
    - If you use a user language other than english, you may want to select a different encoding from the list
    - Otherwise just use "330" to skip locale generation
  - Continue at [Preparing Klipper setup](#preparing-klipper-setup)

The next steps are **only required for the community image** (scroll down otherwise):
- c) WiFi with a community image:
  - Answer "y" to "connect via wireless?" (or just press ENTER)  
    (Sadly, this just continues without asking to connect it to an access point, so no internet yet)
  - Set up Wifi using "armbian-config"
    - Execute `armbian-config`
    - Select "Network"
    - Select "NE001 - Configure network interfaces"
    - Select "NE002 - Add / change interface"
    - Select "wlan0 unassigned[wifi]"
    - Select "sta Connect to access point"
    - Select your access point from the list
    - Use "OK" to accept and "Yes" to confirm the settings
    - Quit armbian-config
  - Install NetworkManager:  
    Execute `apt update && apt install network-manager`
  - Disable networkd:
    - Execute `systemctl disable systemd-networkd.service`
  - Switch to NetworkManager:
    - Execute `armbian-config`
    - Select "Network"
    - Select "NE001 - Configure network interfaces"
    - Select "NE003 - Revert to Armbian defaults"  
      (this step changes /etc/netplan/10-dhcp-all-interfaces.yaml from networkd to NetworkManager)
  - Set up WiFi using NetworkManager:
    - Execute `nmtui`
    - Activate connection
      - select accesspoint
      - enter password
  - Troubleshooting network:
    - Check this, if the screen has a long boot delay waiting for "systemd-networkd-wait-online.service".
    - List the contents of "/etc/netplan/":  
      Execute `ls -l /etc/netplan/`
      - There should be no other file but "10-dhcp-all-interfaces.yaml".
      - Edit this file using `nano /etc/netplan/10-dhcp-all-interfaces.yaml`
      - Make sure it reads "renderer: NetworkManager" and not "renderer: networkd"  
	(otherwise change that line in the editor and save it).

### Preparing Klipper setup
- If you didn't generate locales, you may want to set your timezone:
  - Execute `tzselect`  
    (just follow the prompts to choose your timezone)

The following steps require a working internet connection

- Download and install the [Klipad50 DTB fix](klipad50-dtb-fix.html):  
  (Automatically reinstalls [rk3328-mkspi.dtb](files/rk3328-mkspi.dtb) whenever a dtb-package install/remove has been detected.
  Idea based on <https://askubuntu.com/questions/63717/execute-command-after-dpkg-installation>)
```
wget https://torte71.github.io/tmteststuff/files/klipad50-dtb-fix.deb
dpkg -i klipad50-dtb-fix.deb
```
<!-- DONT USE YET --- wget https://torte71.github.io/InsideSovolKlipperScreen/files/klipad50-dtb-fix.deb  -->

- Install "git" (required for downloading KIAUH):  
  Execute `apt install git`

### Setting up Klipper

{: .note }
> The next steps should be done as the Klipper user (these examples use "mks").
>
> *Do not do it as "root"!*
>
> So either use `exit` in the serial connection to log out and log in again as "mks"
> or use ssh/Putty to log into the device (as "mks").
>
> (If the command prompt reads "root@mkspi", you are using the root account)

- Set up Klipper
  - Download and start KIAUH:
```
cd
git clone https://github.com/dw-0/kiauh
cd /kiauh
./kiauh.sh
```
  - Use the default setting for *every* question (i.e. just press ENTER, unless it asks for a password)
  - Skip options 5 and 6 from the "Install" menu, but select all other
  - Choose the following options:
    - 1 (Yes) ("Try KIAUH v6?")
      - 1 (Install)
	- 1 (Klipper)
	- 2 (Moonraker)
	- 3 (Mainsail)
	- 4 (Fluidd)
	- 7 (KlipperScreen)
	- 8 (Crowsnest)
	- B (Back)
      - E (Extensions)
	- 1 (G-Code Shell Command)
	  - 1 (Install)
	- B (Back)
      - Q (Quit)

- Adjust screen rotation  
  - Execute `sudo nano /etc/X11/xorg.conf.d/01-armbian-defaults.conf`
  - Copy this text:
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
    - Press \<CTRL-X\> to quit
    - Press "Y" to save
    - Press ENTER to confirm filename
    - Restart KlipperScreen:
      - Execute `sudo service KlipperScreen restart`

- Set up numpy (required for input shaping)
  - Execute
```
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
~/klippy-env/bin/pip install -v numpy
```

- Set up secondary mcu: (see <https://www.klipper3d.org/RPi_microcontroller.html>)
  - Execute `cd ~/klipper ; make menuconfig`
  - Select "Micro-controller Architecture" (press ENTER)
  - Select "Linux process" (press ENTER)
  - Press "Q" and "Y" to quit and save
  - Execute
```
make
sudo make flash
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
sudo service klipper restart
```

- Compile Klipper for "mcu" (the printer board)  
  (as from https://github.com/bassamanator/Sovol-SV06-firmware/discussions/111):
  - Execute `cd ~/klipper`
  - Execute `make menuconfig`
  - Change following settings ("=" are unchanged defaults)
    - = Enable extra low-level configuration options: [ ]
    - \* Micro-controller Architecture: STMicroelectronics STM32
    - \* Processor model: STM32F103
    - \* Bootloader offset: 28KiB bootloader
    - \* Communication interface: Serial (on USART1 PA10/PA9)
  - Execute `make clean && make`
  - Copy "out/klipper.bin" to SD-card and rename it (must end in ".bin")  
    !!! Use a different name than that from prior updates !!!

Now you should have a working Klipper installation (with just a basic "printer.cfg").

### Adding Makerbase services/additions  
(See [sovol_mods](sovol_mods.html) for details about the packages)

{: .note }
> The next steps need to be done as root. Execute
>
````
sudo su
cd
```
>
> And when you are done, execute `exit` to switch back to the default user.

  * **Beeps when pressing touchscreen**
    * Uses [makerbase-beep-service.deb](files/makerbase-beep-service.deb)
    * To install, execute 
```
wget https://torte71.github.io/tmteststuff/files/makerbase-beep-service.deb
dpkg -i makerbase-beep-service.deb
```
      * Fix access rights to gpio82:
        * Execute `nano /etc/rc.local`
        * Add following lines (before the `exit 0` line)
```
if [ ! -d "/sys/class/gpio/gpioi82" ]; then
  echo 82 > /sys/class/gpio/export
fi
chgrp mks /sys/class/gpio/gpio82/value
chmod g+w /sys/class/gpio/gpio82/value
```
        * Save and exit the editor
    * To uninstall:
      * Execute `sudo dpkg -r makerbase-beep-service`

  * **Automounting USB-drive**
    * Uses [makerbase-automount-service.deb](files/makerbase-automount-service.deb)
    * To install, execute 
```
wget https://torte71.github.io/tmteststuff/files/makerbase-automount-service.deb
dpkg -i makerbase-automount-service.deb
```
    * To uninstall:
      * Execute `sudo dpkg -r makerbase-automount-service`

  * **Makerbase-soft-shutdown**
    * Uses [makerbase-soft-shutdown-service.deb](files/makerbase-soft-shutdown-service.deb)
    * To install, execute 
```
wget https://torte71.github.io/tmteststuff/files/makerbase-soft-shutdown-service.deb
dpkg -i makerbase-soft-shutdown-service.deb
```
    * To uninstall:
      * Execute `sudo dpkg -r makerbase-soft-shutdown-service`

  * **Powerloss recovery (plr)**
    * Uses unofficial package: [plr-klipper.deb](files/plr-klipper.deb)
    * To install, execute 
```
wget https://torte71.github.io/tmteststuff/files/plr-klipper.deb
dpkg -i plr-klipper.deb
```
    * To uninstall:
      * Execute `sudo dpkg -r plr-klipper`
    * Sovol's [printer.cfg](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration) makes use of `plr`, so it's recommended to either install this package, or remove these entries as shown [here](sovol_mods.html#reverting)

  * **Splash screen**
    * Afaik it's not possible to directly use Sovols original boot animation, as it is in a different format (old kernel based vs. actual plymouth). The file resides in `/usr/lib/firmware/bootsplash.armbian` and is ~250MB big. I haven't found a way to decompile it into separate pictures - if someone does, it will probably be possible to "cook" a plymouth style boot animation from it.
      * Rebuilding splash screens should be possible using [bootsplash-packer](https://github.com/armbian/build/tree/master/packages/blobs/splash) from the "armbian/build" repository (do `git clone https://github.com/armbian/build` and find it in `./packages/blobs/splash/`).\
        Source of the [linux-bootsplash](https://github.com/philmmanjaro/linux-bootsplash) with [documentation](https://github.com/philmmanjaro/linux-bootsplash/blob/master/0010-bootsplash.patch)\
	(thanks to nubecoder for [investigation](https://github.com/torte71/InsideSovolKlipperScreen/issues/3#issuecomment-2585248153))
    * Enable plymouth splash screen:
      * Become root: Execute `sudo su` (enter password when asked)
      * Edit `/boot/armbianEnv.txt` and change it to `bootlogo=true`
      * List available themes: Execute `plymouth-set-default-theme -l`
      * Select a theme (e.g. "solar"): Execute `plymouth-set-default-theme solar ; update-initramfs -u`
      * Restart the system: Execute `reboot`
      * Themes are defined in `/usr/share/plymouth/themes/`

### Adding printer.cfg
If you have backups of your config files, you can upload them using mainsail or fluidd.

Otherwise you can download a default config for your printer.  
I recommend using one from [my fork](https://github.com/torte71/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration)
rather than from [Sovol's site](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration),
as Sovol's version of the SV06+ config is still broken.

For the ready-to-use images I use the standard (non-plus) SV06 config, as it has the smallest bed defined,
so the printhead/bed will not accidentally ram into the endstops on the non-plus models.

