' Used to run the bot in the background automatically.

Dim WinScriptHost
Set WinScriptHost = CreateObject( "WScript.Shell" )
WinScriptHost.Run Chr( 34 ) & "run.bat" & Chr( 34 ), 0
Set WinScriptHost = Nothing
