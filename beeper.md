---
title: Beeper macro
layout: page
parent: Configuring
nav_order: 2
---
# Beeper macro (for use in Klipper)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Description
The "BEEP" macro allows Klipper to emit beeps, e.g. to signal filament change, cancelled prints and similar.

It is based on the solution by "Bastian" at <https://forum.sovol3d.com/t/use-beeper-from-mks-sbc-which-pin/3606/5>.

There are two slightly different approaches:
  * a) Klipper directly accesses the GPIO
  * b) GPIO is handled by shell script, which is called from Klipper via gcode-shell-command
  
Option a) does not depend on "gcode-shell-command", but it does not work together with "makerbase-beep-service", so touching the screen will not beep any longer. (The makerbase service requires the GPIO pin to be exported, but Klipper requires it to be unexported.)

In order to not break the touchscreen beeps, I prefer option b) using the external shell script.

## System setup (set access rights, export gpio pin)
  * Requires udev rule to change rights for gpio access
    * Based on solution by "MikeDK" on <https://forums.raspberrypi.com/viewtopic.php?t=9667>
    * Create `/etc/udev/rules.d/90-gpio.rules`:
```
SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", PROGRAM="/bin/sh -c 'chown root:dialout /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add", PROGRAM="/bin/sh -c 'chown root:dialout /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
```
    * If you are **not** installing [makerbase-beep-service](makerbase-beep-files.html), then you need to set up gpio82 at boot time.
      Insert following code to `/etc/rc.local` (after the lines starting with '#', but before the 'exit 0' line):
```
echo 82 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio82/direction
```

## Klipper setup (add macro "BEEP")
  * Requires [gcode-shell-command](https://github.com/dw-0/kiauh/blob/master/docs/gcode_shell_command.md)
  * Add BEEP macro to `/home/mks/printer_data/config/printer.cfg`:

{% raw  %}
```
[gcode_macro BEEP]
gcode:
  {% set beep_count = params.BC|default("3") %}
  {% set beep_duration = params.BD|default("0.2") %}
  {% set pause_duration = params.PD|default("1") %}
  RUN_SHELL_COMMAND CMD=beep PARAMS='{beep_count} {beep_duration} {pause_duration}'

[gcode_shell_command beep]
command: bash /home/mks/printer_data/config/macro/macro_beep.sh
timeout: 10
verbose: False
```
{% endraw  %}

## Add shell script ("macro_beep.sh")
  * Create `/home/mks/printer_data/config/macro/macro_beep.sh`:

{% raw  %}
```
#!/bin/bash
# usage: beep.sh [BEEPCOUNT] [BEEPDURATION] [PAUSEDURATION]

# Output raw passed parameters
echo "Raw parameters: $@"

# Default values
BEEPCOUNT=${1:-3}
BEEPDURATION=${2:-0.1}
PAUSEDURATION=${3:-0.5}

# Output all passed parameters
echo "Beep count: $BEEPCOUNT, beep duration: $BEEPDURATION, pause duration: $PAUSEDURATION"


# Function to play a beep
play_beep() {
    echo 1 > /sys/class/gpio/gpio82/value
    sleep $BEEPDURATION
    echo 0 > /sys/class/gpio/gpio82/value
}

# Play the beep for the specified count
for (( i=0; i<BEEPCOUNT; i++ )); do
    play_beep
    sleep $PAUSEDURATION
done
```
{% endraw  %}
  * Make the shell script executable:
    * Execute `chmod +x /home/mks/printer_data/config/macro/macro_beep.sh`

## Invocation

The new "BEEP" macro can now be used in your printer.cfg. It supports following parameters:
- `BC=xxx`
  - The number of beeps (**B**eep **C**ount)
  - Must be a whole number like 1, 2, 3, ...
  - Default value: 3
- `BD=x.y`
  - The length of one beep in seconds (**B**eep **D**uration)
  - Allows fractional numbers like 0.3
  - Default value: 0.2
- `PD=x.y`
  - The length of the pause after one beep in seconds (**P**ause **D**uration)
  - Allows fractional numbers like 0.3
  - Default value: 1

All parameters are optional, default values will be used when they are not given.

### Simple example without parameters
```
[gcode_macro M600]
gcode:
    RESPOND TYPE=echo MSG="Change filament"
    BEEP
    SAVE_GCODE_STATE NAME=M600_state
    PAUSE
    RESTORE_GCODE_STATE NAME=M600_state
```

### Example with parameters
```
[gcode_macro M600]
gcode:
    RESPOND TYPE=echo MSG="Change filament"
    BEEP BC=3 BD=1 BP=0.1
    SAVE_GCODE_STATE NAME=M600_state
    PAUSE
    RESTORE_GCODE_STATE NAME=M600_state
```

