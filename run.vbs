' This is used to run the bot in the background automatically.
' Place a shortcut to this file in your start menu startup folder to have it run when your PC starts.

Dim WinScriptHost
Set WinScriptHost = CreateObject( "WScript.Shell" )
WinScriptHost.Run Chr( 34 ) & "C:\Projects\LambdaGamingAnnouncementBot\run.bat" & Chr( 34 ), 0
Set WinScriptHost = Nothing
