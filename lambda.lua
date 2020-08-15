local discordia = require( "discordia" )
local client = discordia.Client()
local token = io.open( "token.txt", "r" )
local servers = {
	[1] = {
		ShortName = "cityrp",
		Name = "CityRP (Garry's Mod)",
		Description = "Plays like the default DarkRP gamemode but more advanced and takes place in a modern city environment. Rules are similar to those seen on Lawless RP servers.",
		Public = true
	},
	[2] = {
		ShortName = "hlurp",
		Name = "Half-Life Universe RP (Garry's Mod)",
		Description = "Custom gamemode based on the major events of the official Half-Life games.",
		Public = true
	},
	[3] = {
		ShortName = "sandbox",
		Name = "Sandbox (Garry's Mod)",
		Description = "Server from an old community, contains addons from other servers put together in a sandbox environment with dozens of maps.",
		Public = true
	},
	[4] = {
		ShortName = "various",
		Name = "Various Gamemodes (Garry's Mod)",
		Description = "This server currently hosts the following gamemodes: Cops and Runners, Flood, Homicide, Jazztronauts, Prop Hunt, Pirate Ship Wars Remix, Pirates Vs Boners, Dropzone, Sledbuild, Stop it Slender, TTT, Trash Compactor, and Zombie Survival.",
		Public = true
	},
	[5] = {
		ShortName = "zombie",
		Name = "Zombie RP (Garry's Mod)",
		Description = "Custom RP gamemode that's sort of a mix between CityRP and Zombie Survival.",
		Public = true
	},
	[6] = {
		ShortName = "rok",
		Name = "Reign of Kings",
		Description = "Medieval survival game.",
		Public = true
	},
	[7] = {
		ShortName = "hldms",
		Name = "Half-Life Deathmatch: Source",
		Description = "Half-Life deathmatch with more bugs.",
		Public = true
	},
	[8] = {
		ShortName = "hl2dm",
		Name = "Half-Life 2 Deathmatch",
		Description = "Classic toilet throwing.",
		Public = true
	},
	[9] = {
		ShortName = "tf2",
		Name = "Team Fortress 2",
		Description = "Hat simulator.",
		Public = true
	},
	[10] = {
		ShortName = "hldm",
		Name = "Half-Life Deathmatch",
		Description = "OG deathmatch.",
		Public = true
	},
	[11] = {
		ShortName = "ricochet",
		Name = "Ricochet",
		Description = "#1 greatest game of all time.",
		Public = true
	},
	[12] = {
		ShortName = "tfc",
		Name = "Team Fortress Classic",
		Description = "Hat simulator: boomer edition.",
		Public = true
	},
	[13] = {
		ShortName = "cs",
		Name = "Counter-Strike 1.6",
		Description = "Classic multiplayer shooter.",
		Public = true
	},
	[14] = {
		ShortName = "hlopdm",
		Name = "Half-Life: Opposing Force Deathmatch",
		Description = "Adrian?",
		Public = true
	},
	[15] = {
		ShortName = "insurgency",
		Name = "Insurgency",
		Description = "Counter-Strike with extra steps.",
		Public = true
	},
	[16] = {
		ShortName = "vanilla",
		Name = "Vanilla (Minecraft)",
		Description = "Always runs the most up-to-date version of the game, not including snapshots.",
		Public = false
	},
	[17] = {
		ShortName = "modded",
		Name = "OG Modded (Minecraft)",
		Description = "Normal survival with basic rules, runs with around 50 mods on version 1.12.2.",
		Public = false
	},
	[18] = {
		ShortName = "unbalanced",
		Name = "Unbalanced (Minecraft)",
		Description = "Normal survival with little rules. Runs with around 60 OP mods that were rejected from the other servers. Runs on version 1.12.2. Only runs on beefy PCs!",
		Public = false
	},
	[19] = {
		ShortName = "city",
		Name = "City Build (Minecraft)",
		Description = "The main goal of this server is to cooperatively build a giant city using various mods to make the process go faster and look nicer. Runs on version 1.12.2.",
		Public = false
	},
	[20] = {
		ShortName = "rlcraft",
		Name = "RLCraft (Minecraft)",
		Description = "Runs the most recent version of the RLCraft modpack. Not recommended for people with low amounts of patience.",
		Public = false
	},
	[21] = {
		ShortName = "earth",
		Name = "Earth (Minecraft)",
		Description = "Runs the 1:1 scale Earth mod along with various other mods with the goal of simply building. All players get admin, some rules are in place to avoid abuse. Runs on version 1.12.2.",
		Public = false
	},
	[22] = {
		ShortName = "scp",
		Name = "SCP: Secret Laboratory",
		Description = "Multiplayer Containment Breach with improved graphics. Server runs various plugins to keep replayability up and repetition down.",
		Public = false
	},
	[23] = {
		ShortName = "protocol",
		Name = "Broke Protocol: Online City RPG",
		Description = "Cool indie game that sorta mixes Minecraft with CityRP and GTA Online.",
		Public = false
	},
	[24] = {
		ShortName = "sven",
		Name = "Sven Co-Op",
		Description = "Multiplayer Half-Life. Server can also support some mods such as Crack-Life.",
		Public = false
	},
	[25] = {
		ShortName = "kf2",
		Name = "Killing Floor 2",
		Description = "Zombie Survival 2.",
		Public = false
	},
	[26] = {
		ShortName = "synergy",
		Name = "Synergy",
		Description = "Multiplayer Half-Life 2. Also supports Episodes 1 and 2.",
		Public = false
	}
}

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
	if split[1] == "!test" then
		message.channel:bulkDelete( allmessages )
		message.channel:send( "Lambda Gaming Announcement Bot successfully loaded. Running on Lua 5.3" )
	elseif split[1] == "!opening" then
		if author.id ~= "580873862036717572" then
			message:reply( "Only OP can use this command." )
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
	end
end )

io.input( token )
client:run( "Bot "..io.read() )
