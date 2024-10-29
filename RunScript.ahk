/*
With AHK, you can list as many hotkeys as you want in a single script.

The below example inserts audio.wav into the timeline when Ctrl + Alt + B is pressed.
To add more, copy and paste the below block, changing the hotkey and the command as needed.

For more information, see the AHK docs: https://www.autohotkey.com/docs/v1/
*/

^!b:: ; Ctrl + Alt + B
    Run wscript "C:\Tools\Fu.vbs" "C:\Tools\SFX.lua" "audio.wav" 2
return
