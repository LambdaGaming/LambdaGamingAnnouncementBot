require( "servers" )
local xml2lua = require( "xml2lua" )
local handler = require( "xmlhandler.tree" )
local discordia = require( "discordia" )
local client = discordia.Client()
local token = io.open( "token.txt", "r" )

client:on( "ready", function()
	print( "Logged in as "..client.user.username )
end )

client:on( "messageCreate", function( message )
	local author = message.author
	local content = message.content
	local getsplit = string.gmatch( content, "%S+" )
	local allmessages = message.channel:getMessages()
	local split = {}
	for i in getsplit do
		table.insert( split, i )
	end
	if split[1] == "!opening" then
		if not message.member:hasPermission( 8 ) then
			message:reply( "Only superadmins can use this command." )
			return
		end

		local numsplit = tonumber( split[2] )
		if not split[2] then
			message:reply( "Please input a number or server name as the second argument for the opening command." )
			return
		end
		if type( numsplit ) == "number" and not servers[numsplit] then
			message:reply( "Input index number is out of range." )
			return
		end

		if type( numsplit ) ~= "number" then
			local foundstring = false
			for k,v in pairs( servers ) do
				if string.lower( v.ShortName ) == string.lower( split[2] ) then
					foundstring = true
					numsplit = k
					break
				end
			end
			if not foundstring then
				message:reply( "The name you input is invalid." )
				return
			end
		end

		local tbl = servers[numsplit]
		local public
		if tbl.Public then
			public = "Yes"
		else
			public = "No"
		end
		message.channel:bulkDelete( allmessages )
		message:reply( ">>> @everyone\n__**Server Opening!**__\n\n**Server: **"..tbl.Name.."\n\n**Description: **"..tbl.Description.."\n\n**Is the server public?: **"..public )
	elseif split[1] == "!update" then
		if not message.member:hasPermission( 8 ) then
			message:reply( "Only superadmins can use this command." )
			return
		end

		os.execute( "rss.bat" ) --I'm just gonna hand this over to a python script since I'm too lazy to figure out how to make http requests in lua

		local xml = xml2lua.loadFile( "temp.xml" )
		local parser = xml2lua.parser( handler )
		parser:parse( xml )

		local rss = handler.root.rss.channel
		local latest = rss.item[1].link
		message:reply( latest )
		message:delete()
	end
end )

io.input( token )
client:run( "Bot "..io.read() )
