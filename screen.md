---
title: Screen rotation
layout: page
parent: Configuring
//nav_order: 12
---
# Screen rotation (for KlipperScreen)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

  * Rotation: Edit /etc/X11/xorg.conf.d/01-armbian-defaults.conf
    * default:
```
Section "Device"
        Identifier "default"
        Driver "fbdev"
        Option "Rotate" "CW" #这里是翻转的方向，"CW" (clockwise, 90 degrees), "UD" (upside down, 180 degrees) and "CCW" (counter clockwise, 270 degrees)
EndSection
```
    * rotated left 90°
```
Section "Device"
        Identifier "default"
        Driver "fbdev"
        #Option "Rotate" "CW" #这里是翻转的方向，"CW" (clockwise, 90 degrees), "UD" (upside down, 180 degrees) and "CCW" (counter clockwise, 270 degrees)
EndSection
Section "InputClass"
        Identifier "libinput touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "TransformationMatrix" "1 0 0 0 1 0 0 0 1"
EndSection
# 0°                                      1 0 0 0 1 0 0 0 1
# 90° Clockwise                           0 -1 1 1 0 0 0 0 1
# 90° Counter-Clockwise                   0 1 0 -1 0 1 0 0 1
# 180° (Inverts X and Y)                  -1 0 1 0 -1 1 0 0 1
# invert Y                                -1 0 1 1 1 0 0 0 1
# invert X                                -1 0 1 0 1 0 0 0 1
# expand to twice the size horizontally   0.5 0 0 0 1 0 0 0 1
```

    * portrait mode for redrathnure's image:
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

----
Back to [start](index.html)
