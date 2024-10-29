; Inserts audio.wav when Ctrl + Alt + B is pressed
^!b::
    Run, wscript "C:\Tools\Fu.vbs" "C:\Tools\SFX.lua" "audio.wav" 2
return