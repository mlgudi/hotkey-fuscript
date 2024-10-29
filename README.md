# Hotkey FuScript
A tiny VB script wrapper to help trigger Lua scripts for Resolve/Fusion externally and silently, with support for arguments and logging.

**Note**: FuScript is only available in DaVinci Resolve Studio.

*I am mostly putting this here as it is part of a larger [StreamDeck](https://www.elgato.com/us/en/p/stream-deck-mk2-black) setup I will later be detailing. The setup allows StreamDeck keys to insert media into the timeline, and for both the media pool bins and StreamDeck keys to be synced with the content of a directory.*

### Purpose
The script is a very simple VBScript wrapper. It runs a Lua script with the arguments you provide while suppressing the FuScript shell (making it suited for hotkeys).

The purpose is to allow for faster, more flexible hotkey creation with the ability to pass args.

### Setup
1. Locate your `fuscript.exe`:
   - It's in the same directory as `Resolve.exe`
   - To find the path, either:
     - Right-click your Resolve shortcut → "Open file location"
     - Run `print(bmd:getcurrentdir())` in the Fusion console

2. Add to PATH:
   - Add the directory containing `fuscript.exe` to your system's PATH
   - [Quick video walkthrough if you are unsure of how to do this](https://www.youtube.com/watch?v=pGRw1bgb1gU)

3. Download [Fu.vbs](Fu.vbs):
   - Place in an easily accessible location, ideally somewhere with a short path
   - If you don't want output logging, download [FuMin.vbs](FuMin.vbs) instead and optionally rename it to `Fu.vbs`

### Usage
To run a Lua script with arguments, use the following command:

`wscript <path to Fu.vbs> <path to Lua script> [script arguments]`

### Accessing Arguments in Lua
Arguments are available through the global `arg` table:
- `arg[0]`: Path to the Lua script (reserved)
- `arg[1]`: First user argument
- `arg[2]`: Second user argument
- etc.

All args are strings, so you will need to use tonumber() and such.

### Viewing Output
If you are using [Fu.vbs](Fu.vbs), output will be logged to `Fu_Logs/YYYY-MM-DD.log` in the same directory as `Fu.vbs`. No output will be displayed in the Resolve/Fusion console.

### SFX Example
You can see an example of a compatible script in [SFX.lua](SFX.lua). It is a simplified version of a script I regularly use to insert sound effects into the timeline at the current timecode from the media pool.

I have both `Fu.vbs` and `SFX.lua` in `C:\Tools`. So, to insert `audio.wav` into audio track 2 from my media pool, I would run:

`wscript "C:\Tools\Fu.vbs" "C:\Tools\SFX.lua" "audio.wav" 2`

This script is a simplified example and I don't recommend using it. It searches the entire media pool for the clip, which will be very slow in larger projects.

*If you'd like a more complete script with similar functionality, see [SFX_full.lua](SFX_full.lua). It is more convoluted, but avoids searching the entire bin each run. It stores bin paths in the `fusion` global using `fusion:SetData()` on the first execution.*
