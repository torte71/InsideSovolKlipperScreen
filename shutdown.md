---
title: Shutdown
layout: page
nav_order: 7
has_toc: false
---
# Klipper Shutdown (Windows version)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

{: .warning }
> **Do not simply power off the device by the switch.**
> 
> **Shut it down using either the web interface or the buttons on the KlipperScreen first.**
> 
> **Just powering it off can -and does- lead to damaged files.**

----

## Shutdown using scripts

I am using a set of batch files to power my printer on and off safely by first sending a "shutdown" command to the device via ssh (actually Putty's plink.exe) and then sending a shutdown command to my hs110 wifi power plug.

(Actually it is first checked, if the device is powered on (reacts to "ping"). If it does not respond, the hs110 is powered off immediately. Otherwise a "shutdown" command is issued to the device and the script waits until the device stops responding to "ping". After an additional pause of 7 seconds, the hs110 is finally powered off).

These scripts are not limited to Sovol's KlipperScreen, they can be used with any hardware running linux (they do not even depend on klipper). Just make sure to a) adjust the variable `PRINTER` in `mks_poweroff.cmd` and `shutdown_sv06.cmd` to the name or IP-address of your device and b) adjust the variable `USERNAME` in `mks_poweroff.cmd` to the username on your device.

## Requirements
  * HS110 wifi power plug
  * Putty "plink.exe" from <https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html>
  * Putty "puttygen.exe" key generator from <https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html>
  * softScheck "tplink_smartplug.py" from <https://github.com/softScheck/tplink-smartplug/tree/master>
  * Python from the [Microsoft store](https://apps.microsoft.com/detail/9pjpw5ldxlz5?hl=en-us) or from <https://www.python.org/>
  * For passwordless login (optional, but recommended):
    * ssh key on the KlipperScreen device to allow passwordless login
    * modified /etc/sudoers.conf to allow passwordless shutdown

## The files
  * `hs110_off.cmd`: Sends a power off command to the HS110 wifi plug
  * `hs110_on.cmd`: Sends a power on command to the HS110 wifi plug
  * `mks_poweroff.cmd`: Sends a shutdown command to the KlipperScreen
  * `shutdown_sv06.cmd`: Shuts down the KlipperScreen, then powers it off using the HS110 wifi plug
  * `tplink_smartplug.py`: Sends commands to the HS110. See above link to download it.

These 5 files need to be put into the same directory.

If nothing went wrong, you should now be able to shutdown and power off the printer by executing `shutdown_sv06.cmd`.

To power it on, execute `hs110_on.cmd`.

----

### hs110_off.cmd
  * Replace the "192.168.1.60" with the actual IP address of your HS110 wifi power plug.
  * See [Troubleshooting](#troubleshooting) if this command does not power off the device  
```
tplink_smartplug.py -t 192.168.1.60 -c off
```

### hs110_on.cmd
  * Replace the "192.168.1.60" with the actual IP address of your HS110 wifi power plug.
  * See [Troubleshooting](#troubleshooting) if this command does not power on the device  
```
tplink_smartplug.py -t 192.168.1.60 -c on
```

### mks_poweroff.cmd
  * Adjust PRINTER to the name or IP address of your KlipperScreen device
  * Adjust PLINKCMD to match your putty installation.
  * For login using clear text password (not recommended, but simpler):
    * Adjust PASSWORD (if you changed it to something other than the default `makerbase`)
    * Leave PLINKKEY blank
  * For passwordless login using ssh key (recommended):
    * Set PLINKKEY to match your generated ssh key.
    * Clear out PASSWORD
  * For other hardware than Sovol's KlipperScreen:
    * Adjust USERNAME, e.g. to `pi` on a default Raspbian installation

```
@echo off

rem #### best practice is using a PLINKKEY instead of a cleartext PASSWORD

set PRINTER=mkspi
set USERNAME=mks
set PLINKCMD=c:\putty\plink.exe
set PLINKKEY=
set PASSWORD=makerbase
rem set PLINKKEY=c:\putty\printer.ppk
rem set PASSWORD=

rem #### nothing should be changed below here

rem MKSPI: allow user "mks" to shutdown/reboot/halt (without "sudo" asking for a password):
rem        add following to /etc/sudoers.conf (run "visudo"):
rem        mks ALL=NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff

set POWERCMD="sudo poweroff"

set OPTKEY=
if %PLINKKEY%x==x goto SETPW
set OPTKEY=-i %PLINKKEY%

:SETPW
set OPTPW=
if %PASSWORD%x==x goto LOGIN
set OPTPW=-pw %PASSWORD%
set POWERCMD="echo %PASSWORD%|sudo -S poweroff"

:LOGIN
%PLINKCMD% %OPTPW% %OPTKEY% -batch %USERNAME%@%PRINTER% %POWERCMD%
```

### shutdown_sv06.cmd
  * Adjust PRINTER to the name or IP address of your KlipperScreen device

```
@echo off

set PRINTER=mkspi

rem try to ping MKSPI
ping -n 1 -w 1000 %PRINTER% >NUL
rem bail out, if MKSPI did not respond
if errorlevel 1 goto smartplug_off

echo Shutting down MKSPI
call mks_poweroff.cmd

rem doc: PRINT ON SAME LINE: "<NUL set /p =TextToDisplay"
<NUL set /p =Waiting for MKS to shutdown
:pingloop
rem echo "." on same line
<NUL set /p =.
rem try to ping MKSPI
ping -n 1 -w 1000 %PRINTER% >NUL
rem bail out, if MKSPI did not respond
if errorlevel 1 goto did_shutdown
rem otherwise wait a second
ping -n 2 127.0.0.1 >NUL
rem then try next ping
goto pingloop

:did_shutdown
echo MKS has shut down.
echo Waiting additional 7 seconds...
ping -n 8 127.0.0.1 >NUL

:smartplug_off
echo Power off HS110 smartplug...
call hs110_off
```

----

# Advanced: Passwordless login and shutdown using ssh key and visudo

## Preparing the ssh key
  * Start `puttygen.exe`
  * Select the "EdDSA" radiobox
  * Click the "Generate" button
  * Press the "Save private key" button
    * Confirm that there is no passphrase by clicking the "Yes" button
  * Give it a filename, e.g. `printer.ppk`
  * Click into the upper box and select its content  
    (it should start with `ssh-ed25519 ` followed by a lot of gibberish)
  * Open Notepad (or any other text editor), paste the content there and save it for later use, e.g. as "printer_pubkey.txt"
  * Start `Putty.exe`, enter `mkspi` (or the IP address of your KlipperScreen) into the "Host Name" edit field
    * Click on the "Open" button to connect
    * Enter "mks" as username
    * Enter "makerbase" as password
  * Copy the public key into `~/.ssh/authorized_keys`:
    * Execute `mkdir -p .ssh`
    * Execute `nano .ssh/autorized_keys`
    * Paste your public key (the gibberish line saved into `printer_pubkey.txt`)
    * Press `CTRL`+`X` to exit
    * Press `Y` to confirm saving
    * Press `ENTER` to confirm the filename

## Testing the ssh key
  * Open a command prompt
  * Adjust the paths to plink and the saved key, and replace "mkspi" by the name or IP address of your KlipperScreen, then execute it:  
    `c:\putty\plink.exe -i c:\putty\printer.ppk -batch mks@mkspi sudo poweroff`  
    (Also replace "mks" with the actual username when not using Sovol's KlipperScreen)
  * When you connect first, plink will ask to save a fingerprint. Press "y" to confirm that.
  * You should now be logged into the KlipperScreen without any further input/password prompts.  
    If not, then you've either made a mistake copying the public key to the `authorized_keys` file or selected a wrong private key file.

## Preparing `/etc/sudoers.conf`
  * Execute `sudo visudo`
  * Append following line in the editor that just opened:
  * `mks ALL=NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff`
  * Press `CTRL`+`X` to exit
  * Press `Y` to confirm saving
  * Press `ENTER` to confirm the filename

----

# Troubleshooting
  * HS110 not turning on or off
    * Ensure that the IP-address of the HS110 is correctly set in `hs110_on.cmd` and `hs110_off.cmd`
    * Check if python is correctly installed (see link at the top of this page)
    * Python has to be registered to execute `.py` files.  
    If that does not work:
      * Locate the python binary (e.g. `c:\python\pythonw.exe`)
      * Adjust `hs110_on.cmd` to point to this executable:
        * `c:\python\pythonw.exe tplink_smartplug.py -t 192.168.1.60 -c off`
      * Adjust `hs110_on.cmd` to point to this executable:
        * `c:\python\pythonw.exe tplink_smartplug.py -t 192.168.1.60 -c on`

# Linux version
Linux versions of these scripts are [available here](shutdown_linux).

----
Back to [start](index.html)
