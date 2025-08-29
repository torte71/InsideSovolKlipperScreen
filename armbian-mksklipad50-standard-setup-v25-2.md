---
title: Rebuilding on Armbian standard v25.2.3 (MKS-KLIPAD50)
layout: page
parent: Custom firmware archive
nav_order: 996
has_toc: false
---
# Rebuilding on Armbian standard v25.2.3 (MKS-KLIPAD50)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

Since February 2025, the MKS-Klipad50 board is natively supported by Armbian.

The required Makerbase kernel patches ported by Maxim Medvedev have been integrated into mainline Armbian in December 2024.

This means, that it is now possible to update the kernel like any other package, no more hazzles with replacing DTB files, etc.

## Different image options

You have the choice between Debian Bookworm Minimal/IOT images and Ubuntu Noble Server/CLI images.

See [Armbian images](armbian_images.html#download-options) for a description of the different types and download locations.

<!--
{: .note }
> When using images from the archive:
> - **Use only** images with "Mksklipad50" in their name.
> - Do **not** use images with "desktop" in their filename or description (unless you have extremely small fingers).
-->

{: .important-title }
> Tip
>
> If you have trouble following these steps, you may take a look at Vasyl's guide:
> <https://github.com/vasyl83/SV07update>\
> It covers a previous image version, but can still help understanding the steps on this guide a little better.

## Steps to create a "sovolish" Klipper installation based on these images:

### Downloading and flashing the image
- Choose an image file from these links:\
  (The server images are a little bit easier to set up)
  - Images used for testing:
    - [Armbian 25.5.1 Noble Server / CLI](https://dl.armbian.com/mksklipad50/Noble_current_server)
    - [Armbian 25.5.1 Bookworm Minimal / IOT](https://dl.armbian.com/mksklipad50/Bookworm_current_minimal)
    - Armbian 25.2.3 Noble Server / CLI ([here](https://rsync.armbian.com/incoming/torte71/mksklipad50/archive/); soon to be found in [Archive](https://archive.armbian.com/mksklipad50/archive/))
    - Armbian 25.2.3 Bookworm Minimal / IOT ([here](https://rsync.armbian.com/incoming/torte71/mksklipad50/archive/); soon to be found in [Archive](https://archive.armbian.com/mksklipad50/archive/))
<!-- TODO: Link to https://archive.armbian.com/mksklipad50/archive once available -->    
- Extract the image (e.g. using [7zip](https://www.7-zip.org/)) - or use Etcher or Rufus, which can write .img.xz images directly.
- Write the extracted .img file to the eMMC card (e.g. using [Balena Etcher](https://www.balena.io/etcher/) or [Rufus](https://rufus.ie/en/)).

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
      - Flow control: None (or use XON/XOFF to reduce some onscreen garbage)
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
  - The server image will ask for the "default system command shell"
    - Choose "1" for "bash" (unless you know better)
  - Enter username (e.g. "mks")
  - Enter user password (e.g. "makerbase"), repeat once more
  - Enter real name (e.g. "Mks")

### Network setup
- If you use an USB-Ethernet adapter, skip to "Locale setup"

- If you connect via WiFi:
  - Answer "y" to "connect via wireless?" (or just press ENTER)
  - Select your access point in the dialog
  - Enter your WiFi password

- Locale setup
  - When asked "Set user language based on your location?":
    - Choose what you want. I prefer "no", because untranslated error-messages give better online search results
  - When asked for generating locales:
    - If you use a user language other than english, you may want to select a different encoding from the list
    - Otherwise just skip locale generation (choose the highest/last number on that list)

The next steps are **only required for the minimal image**
- Switch to NetworkManager
  - Install NetworkManager:  
    - Execute `apt update && apt -y install network-manager`
  - Disable networkd:
    - Execute `systemctl disable systemd-networkd.service`
  - Update neplan config
    - Execute `sed -i "/renderer:/ s/networkd/NetworkManager/" /etc/netplan/*.yaml`

### Preparing Klipper setup
- If you didn't generate locales, then you may want to set your timezone:
  - Execute `dpkg-reconfigure tzdata`\
    (This is also possible using armbian-config -\> "Localisation" -\> "Change global timezone")

- Rename your device from "mksklipad50" to "mkspi" (as it was in prior images):
  - Execute `nano /etc/hostname`
  - Replace "mksklipad50" with "mkspi"
  - Press \<CTRL-X\>, "Y", \<ENTER\> to save and confirm the filename.\
    (This is also possible using armbian-config -\> "Localisation" -\> "Change System Hostname")

- Install "git" (required for downloading KIAUH) and "evtest" (required for makerbase-beep-service):
  - Execute `apt install -y git evtest`
  - The Ubuntu Server image already has "git" and "evtest" installed, so you can skip this step.

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
cd kiauh
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

- Adjust screen and touch rotation  
  - Screen rotation: Execute `sudo nano /etc/X11/xorg.conf.d/01-armbian-defaults.conf`
  - Copy this text:
```
Section "Device"
        Identifier "default"
        Driver "fbdev"
        Option "Rotate" "CW"
EndSection
```
    - Press \<CTRL-X\> to quit
    - Press "Y" to save
    - Press ENTER to confirm filename
  - Clean up additional Xorg config:\
    It does not interfere with the above config, but it is cleaner to remove it to avoid duplicate configurations.
    - Execute `sudo rm /etc/X11/xorg.conf.d/02-driver.conf`
  - Touch rotation: Execute `sudo nano /etc/udev/rules.d/99-calibration.rules`
  - Copy this text:
```
#Bus 004 Device 003: ID 1a86:e5e3 QinHeng Electronics USB2IIC_CTP_CONTROL
ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="e5e3", ENV{LIBINPUT_CALIBRATION_MATRIX}="0 1 0 -1 0 1 0 0 1"
```
    - Press \<CTRL-X\> to quit
    - Press "Y" to save
    - Press ENTER to confirm filename
  - Reload udev rules:
    - Execute `sudo udevadm control --reload-rules && udevadm trigger`
  - Restart KlipperScreen:
    - Execute `sudo service KlipperScreen restart`

- Set up numpy (required for input shaping)
  - Execute
```
sudo apt install -y python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
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
    - = Processor model: STM32F103
    - \* Bootloader offset: 28KiB bootloader
    - \* Communication interface: Serial (on USART1 PA10/PA9)
  - Press "Q" and "Y" to quit and save
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

### Cleaning up package cache
This is not required, but you gain ~250MB of free space by removing old downloaded packages:
- Execute `sudo apt clean`

### Adding printer.cfg
If you have backups of your config files, you can upload them using mainsail or fluidd.

Otherwise you can download a default config for your printer.  
I recommend using one from [my fork](https://github.com/torte71/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration)
rather than from [Sovol's site](https://github.com/Sovol3d/SOVOL_KLIPAD50_SYSTEM/tree/main/klipper_configuration),
as Sovol's version of the SV06+ config is still broken.

For the ready-to-use images I use the standard (non-plus) SV06 config, as it has the smallest bed defined,
so the printhead/bed will not accidentally ram into the endstops on the non-plus models.

### Copying Mainsail / Fluidd config
Mainsail and Fluidd store their settings in a database: `~/printer_data/database/moonraker-sql.db`.\
(These also contain metadata for the existing gcode files, like thumbnails, print settings, etc.)

In most cases it is possible to copy your old database, but you should stop the moonraker service before doing this:
- Stop moonraker service: `sudo service moonraker stop`
- Ensure moonraker really has stopped: `sudo service moonraker stop`
  - Make sure the output reads "Active: inactive (dead)" and **not** "Active: active (running)"
- Make a backup of the "database" directory: `cp -a ~/printer_data/database ~/printer_data/database.bak`
- Copy your old "moonraker-sql.db" (and possibly other files existing in your old "database" directory) into the "database" directory
- Restart moonraker: `sudo service moonraker stop`
- If that does not work
  - Try rebooting the device
  - Revert to the old database if you encounter problems
    - Stop moonraker service first (as shown above)
    - Remove the "database" directory: `rm -rf ~/printer_data/database`
    - Rename the backed up "database.bak" back to "database": `mv ~/printer_data/database.bak ~/printer_data/database`
    - Reboot the device

