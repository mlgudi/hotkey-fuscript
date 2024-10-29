Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

strScriptDir = objFSO.GetParentFolderName(WScript.ScriptFullName)
strLogDir = objFSO.BuildPath(strScriptDir, "Fu_Logs")
If Not objFSO.FolderExists(strLogDir) Then
    objFSO.CreateFolder(strLogDir)
End If

strDate = Year(Now) & "-" & Right("0" & Month(Now), 2) & "-" & Right("0" & Day(Now), 2)
strLogFile = objFSO.BuildPath(strLogDir, strDate & ".log")

Set logFile = objFSO.OpenTextFile(strLogFile, 8, True)

logFile.WriteLine "-------------------"
logFile.WriteLine "[" & Time() & "] Arguments received: " & objArgs.Count

If objArgs.Count < 1 Then
    logFile.WriteLine "[" & Time() & "] No arguments provided - exiting"
    logFile.Close
    WScript.Quit
End If

strLuaPath = objArgs(0)
logFile.WriteLine "[" & Time() & "] Lua script path: " & strLuaPath

strTempFile = objFSO.BuildPath(strLogDir, objFSO.GetTempName)

strFuCommand = "fuscript.exe """ & strLuaPath & """"
For i = 1 To objArgs.Count - 1
    strFuCommand = strFuCommand & " """ & objArgs(i) & """"
Next

strCommandWithLogging = "cmd /c " & strFuCommand & " > """ & strTempFile & """ 2>&1"
logFile.WriteLine "[" & Time() & "] " & "FuScript command: " & strFuCommand

objShell.Run strCommandWithLogging, 0, True

If objFSO.FileExists(strTempFile) Then
    Set objTemp = objFSO.OpenTextFile(strTempFile, 1)
    Do Until objTemp.AtEndOfStream
        strLine = objTemp.ReadLine()
        logFile.WriteLine "[" & Time() & "] " & strLine
    Loop
    objTemp.Close
    
    objFSO.DeleteFile(strTempFile)
End If

logFile.WriteLine "[" & Time() & "] Execution completed"
logFile.Close

Set objFSO = Nothing
Set objShell = Nothing