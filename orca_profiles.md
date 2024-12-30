---
title: Orca Profiles
layout: page
nav_order: 2
---
# Orca profiles
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## joescalon SV06+ profile+buildplate
  * <https://www.printables.com/de/model/508400-sv06-plus-profiles-and-build-plate/files>

## my (based on joescalon)
  * My [Orca Profile](files/tm_sv06_klipper_orca_printer_profiles.zip) for klipperized SV06+
  * Modified [buildplate texture](https://www.printables.com/model/1106765-sv06-bed-texture) (adjusted positions/sizes of imprints, added imprinted lines)

----

## joescalon SV07+ profile+buildplate
  * <https://www.printables.com/de/model/575394-sv07-plus-slicer-additions>

## Christian Vicks profiles
  * <https://www.printables.com/de/model/607280-cvs-orcaslicer-presets-for-sovol-sv07-plus-v13b1>

----

## Automatic z-offset adjustment per filament
Some filaments (like PLA, or some transparent PETG) require a lower z-offset for good bed adhesion than others.  
Adjusting the z-offset e.g. by -0.05mm can be achieved by by adding `SET_GCODE_OFFSET Z=-0.05` to the slicer's filament start code and resetting it in the filament end code (add `SET_GCODE_OFFSET Z=0.0` there).  
The filament start end end codes can be found in Orca's material settings window under the "Advanced" tab.

That offset should be reset in your `printer.cfg` as well (to ensure it is reset e.g. after a cancelled print). Add `SET_GCODE_OFFSET Z=0.0` to the end of the sections `[gcode_macro CANCEL_PRINT]` and `[gcode_macro END_PRINT]`.

Summarized:
  * Add `SET_GCODE_OFFSET Z=-0.05` to slicers filament start code
  * Add `SET_GCODE_OFFSET Z=0.0` to
    * slicers filament end code
    * printer.cfg section `[gcode_macro CANCEL_PRINT]`
    * printer.cfg section `[gcode_macro END_PRINT]`

----
Back to [start](index.md)
