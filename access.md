---
title: Getting Access / Log In
layout: page
nav_order: 14
---
# Getting Access / Log In
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

Here you will find several ways to log into the KlipperScreen.

## Serial (over USB)
  * Allows access even in bootloader stage
  * Requirements:
    * USB-C cable
    * Terminal software (e.g. [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html))
  * Instructions:
    * Power on the KlipperScreen
    * Find the com-port in the device manager:
      * On the PC press the "Windows"-key together with the "R" key.
      * In the newly opened window, enter "devmgmt.msc". This opens the device manager.
      * Look for the section with "COM & LPT" and expand it.
      * Now connect the USB-C cable to the KlipperScreen and the PC.
      * A new entry should pop up "USB-SERIAL CH340 (COM\*)" (the "\*" can be any number)
      * The name in brackets is what you have to enter in putty (e.g. "COM3")
    * Download and start putty
    * Configure the com-port in putty:
      * Select "Serial" (quite at the top, below "Connection type:")
      * Enter the name of the com-port (e.g. "COM3", check the previous step for the correct name)
      * Set "Speed" to "1500000" (that's 5 zeroes after the "15")
      * Select "Open"
      * This should open a terminal window
    * In the terminal window press Enter, a new line should appear: `mkspi login: `
    * Enter the name and the password:
      * The default name is `mks`
      * The default password is `makerbase`
    * Congrats, you are logged in.

  * Instructions for entering bootloader:
    * If possible, first try to get the serial connection working as shown above. Entering the bootloader is a bit more difficult and time-critical, so it's good if you already familiarized with that and know, that you have a working serial setup.
    * Enter correct power off state:
      * The KlipperScreen has to be shut-down, but still connected to the power. (If it has no power, the com-port will not exist, and you won't be able to connect to it fast enough to intercept the boot process.)
      * Clean ways to get the KlipperScreen into power-off mode are e.g. a) using the shutdown buttons on the screen of the KlipperScreen b) performing a `sudo poweroff` or `sudo halt` when logged in via serial or SSH
      * A more unclean way is keeping the small power-button on the side pressed for about 10 seconds.
      * In the correct powered off state, the LEDs at the top are off. But you can see a blue LED inside the case when watching through the airholes.
    * Intercept the bootloader:
      * Connect the USB-C cable, start putty and connect to the com-port as shown above
      * Activate the terminal window and keep the spacebar pressed until told otherwise
      * Press the small powerbutton on the side of the KlipperScreen for about 1-2 seconds
      * There should appear a line reading `Hit any key to stop autoboot: 0`.
      * When you see the spaces arriving on the screen, you stop pressing the spacebar.
    * Voilà, you're in the bootloader menu, do what you've been told to do there ;) E.g.:
      * Enter `run bootcmd_usb0` to enter from USB-drive
      * Enter `boot` to continue normal booting
      * Enter `help` for a list of supported commands.

## USB-Keyboard
  * Requirements:
    * USB-keyboard
    * Working display on the KlipperScreen
  * Instructions:
    * Plug in a normal USB-keyboard into any of the KlipperScreen's USB-ports. Rather use a simple keyboard, i.e. not a wireless one and not one that requires special drivers, etc.
    * Have the KlipperScreen powered up
    * Switch to text-mode:
      * At the same time, press the keys "STRG" + "ALT" + "F1" (repeat, if that doesn't work immediately)
      * On success, you will see a lot of text lines (rotated to landscape view).
    * Log in:
      * HINT: In this setup, the keyboard uses US-keylayout! Keep that in mind esp. if you changed your password. E.g. german keyboards have the "y" and "z" keys switched.
      * Enter the username: `mks`
      * Enter the password: `makerbase`
    * The last line is barely visible because of the black frame. Once you are logged in, you can enter `clear` to clear the screen and put the cursor in the top row, so you can see, what you type.

## SSH (putty)
  * Requirements:
    * Terminal software (e.g. [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html))
    * KlipperScreen needs working network access (wifi, ethernet)
  * Instructions:
    * Connect your KlipperScreen to the network
      * Option a) internal wifi:
        * On the KlipperScreen, press the "Menu" icon, then the "Network" icon.
        * It shows a list of the wifi-networks found
        * Select the arrow beneath the desired wifi-network, then enter the wifi-password
      * Option b) external ethernet adapter
        * Most USB-ethernet adapters should work. But of course, not all. :/
        * Connect the ethernet adapter to your network.
        * Make sure that the ethernet port really belongs to your home network. Some ports on your router may use the guest network instead, a connection will not be possible in that case.
        * On the KlipperScreen, press the "Menu" icon, then the "Network" icon.
        * If your ethernet adapter works, it will show up in that network screen.
    * Check the IP-adress:
      * On the KlipperScreen, press the "Menu" icon, then the "Network" icon.
      * Beneath the connection you will find the IP-adress (in doubt, use IPv4). It will look like "192.168.1.123" (3 blocks of max. 3 digits, divided by a point)
    * Download and start putty
    * In the "Host name" field enter the the IP-address, that you've just found out (see above).
    * It will ask you "login as:". Enter `mks` as the username, then enter the password `makerbase`.
    * Caveats:
      * Sometimes putty will open a window with a warning that the connection has changed and may be insecure. Don't worry, this is normal after reinstalling the KlipperScreen. Just accept it, when asks wether it should continue.
      * Using the name "mkspi" instead of numerical IP-address is possible, but can be troublesome:
        * If there are multiple devices with that name, your PC can't know to which it should connect.
        * If the numerical IP-address changes, the name "mkspi" will still point to the old address for some time, because it is cached. The easiest fix is to reboot your PC.


## Accounts
  * The default username is `mks`
  * The default password is `makerbase`
  * You can use `root` as username as well (at least in most situations), it also uses `makerbase` as the password.

## Downloads

  * Putty: <https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html>


----
Back to [start](index.md)

