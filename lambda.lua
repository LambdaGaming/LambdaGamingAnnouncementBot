require( "servers" )
local xml2lua = require( "xml2lua" )
local handler = require( "xmlhandler.tree" )
local discordia = require( "discordia" )
local client = discordia.Client()
local token = io.open( "token.txt", "r" )

local function StartsWith( str, start )
	return string.sub( str, 1, string.len( start ) ) == start
end

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
		message:reply( ">>> <@&"..tbl.Mention..">\n__**Server Opening!**__\n\n**Server: **"..tbl.Name.."\n\n**Description: **"..tbl.Description.."\n\n**Is the server public?: **"..public )
	elseif split[1] == "!update" then
		if not message.member:hasPermission( 8 ) then
			message:reply( "Only superadmins can use this command." )
			return
		end

		local xml = assert( io.popen( "rss.py", "r" ) ):read( "*all" ) --Handing this over to a python script since it's easier to make http requests there
		if StartsWith( xml, "ERROR:" ) then
			message:reply( xml )
			message:delete()
			return
		end

		local parser = xml2lua.parser( handler )
		parser:parse( xml )

		local rss = handler.root.rss.channel
		local title = rss.item[1].title
		local description = rss.item[1].description
		message:reply( ">>> __**"..title.."**__\n"..ParseDescription( description ) )
		message:delete()
	end
end )

io.input( token )
client:run( "Bot "..io.read() )
