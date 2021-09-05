require( "servers" )
local xml2lua = require( "xml2lua" )
local handler = require( "xmlhandler.tree" )
local discordia = require( "discordia" )
local client = discordia.Client()
local token = io.open( "token.txt", "r" )

local function ParseDescription( desc )
	local formats = {
		{ [[<div class="bb_h1">]], "\n**" },
		{ "</div>", "**" },
		{ [[<ul class="bb_ul">]], "" },
		{ "</ul>", "" },
		{ "<li>", "\n\t•" },
		{ "</li>", "" },
		{ "<br><br>", "" },
		{ "<br>", "\n" }
	}
	for k,v in pairs( formats ) do
		desc = string.gsub( desc, v[1], v[2] )
	end
	return desc
end

local function GetAdditionalInfo( split )
	local str = ""
	if split[3] then
		local tbl = split
		tbl[1] = nil
		tbl[2] = nil
		for k,v in pairs( tbl ) do
			str = str..v.." "
		end
		return "\n\n**Additional Info: **"..str
	end
	return ""
end

client:on( "ready", function()
	print( "Logged in as "..client.user.username )
end )

client:on( "messageCreate", function( message )
	local author = message.author
	local content = message.content
	local getsplit = string.gmatch( content, "%S+" )
	local allmessages = message.channel:getMessages( 2 )
	local split = {}
	for i in getsplit do
		table.insert( split, i )
	end
	if split[1] == "!opening" then
		if not message.member:hasPermission( 8 ) then
			message:reply( "Only superadmins can use this command." )
			return
		end
		if not split[2] then
			message:reply( "Please input a number or server name as the second argument for the opening command." )
			return
		end
		if not servers[split[2]] then
			message:reply( "Server name is invalid." )
			return
		end

		local tbl = servers[split[2]]
		local public = tbl.Public and "Yes" or "No"
		local additional = GetAdditionalInfo( split )
		message.channel:bulkDelete( allmessages )
		message:reply( ">>> <@&"..tbl.Mention..">\n__**Server Opening!**__\n\n**Server: **"..tbl.Name.."\n\n**Description: **"..tbl.Description.."\n\n**Is the server public?: **"..public..additional )
	elseif split[1] == "!update" then
		if not message.member:hasPermission( 8 ) then
			message:reply( "Only superadmins can use this command." )
			return
		end

		local xml = assert( io.popen( "rss.py", "r" ) ):read( "*all" ) --Handing this over to a python script since it's easier to make http requests there
		local parser = xml2lua.parser( handler )
		parser:parse( xml )

		local rss = handler.root.rss
		if not rss then
			message:reply( "ERROR: Something went wrong while fetching the RSS feed. No details to provide." )
		end

		local channel = rss.channel
		local title = channel.item[1].title
		local description = channel.item[1].description
		message:reply( ">>> __**"..title.."**__\n"..ParseDescription( description ) )
		message:delete()
	end
end )

io.input( token )
client:run( "Bot "..io.read() )
