Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments
If objArgs.Count < 1 Then
    WScript.Quit
End If

strLuaPath = objArgs(0)
strFuCommand = "fuscript.exe """ & strLuaPath & """"
For i = 1 To objArgs.Count - 1
    strFuCommand = strFuCommand & " """ & objArgs(i) & """"
Next

objShell.Run strFuCommand, 0, False
Set objShell = Nothing