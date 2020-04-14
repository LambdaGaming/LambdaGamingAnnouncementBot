local discordia = require('discordia')
local client = discordia.Client()
local token = io.open( "token.txt", "r" )

client:on( "ready", function()
	print( "Logged in as "..client.user.username )
end )

client:on( "messageCreate", function( message )
	if message.content == "!test" then
		message.channel:send( "Lambda Gaming Announcement Bot successfully loaded. Running on Lua 5.3" )
	end
end )

io.input( token )
client:run( "Bot "..io.read() )
