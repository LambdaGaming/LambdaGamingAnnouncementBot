local discordia = require( "discordia" )
local client = discordia.Client()
local token = io.open( "token.txt", "r" )
local servers = {
	{
		Name = "CityRP (Garry's Mod)",
		Description = "Plays like the default DarkRP gamemode but more advanced and takes place in a modern city environment. Rules are similar to those seen on Lawless RP servers.",
		Public = true
	},
	{
		Name = "Half-Life Universe RP (Garry's Mod)",
		Description = "Custom gamemode based on the major events of the official Half-Life games.",
		Public = true
	},
	{
		Name = "Sandbox (Garry's Mod)",
		Description = "Server from an old community, contains addons from other servers put together in a sandbox environment with dozens of maps.",
		Public = true
	},
	{
		Name = "Various Gamemodes (Garry's Mod)",
		Description = "This server currently hosts the following gamemodes: Cops and Runners, Flood, Homicide, Jazztronauts, Prop Hunt, Pirate Ship Wars Remix, Pirates Vs Boners, Dropzone, Sledbuild, Stop it Slender, TTT, Trash Compactor, and Zombie Survival.",
		Public = true
	},
	{
		Name = "Zombie RP (Garry's Mod)",
		Description = "Custom RP gamemode that's sort of a mix between CityRP and Zombie Survival.",
		Public = true
	},
	{
		Name = "Reign of Kings",
		Description = "Medieval survival game.",
		Public = true
	},
	{
		Name = "Half-Life Deathmatch: Source",
		Description = "Half-Life deathmatch with more bugs.",
		Public = true
	},
	{
		Name = "Half-Life 2 Deathmatch",
		Description = "Classic toilet throwing.",
		Public = true
	},
	{
		Name = "Team Fortress 2",
		Description = "Hat simulator.",
		Public = true
	},
	{
		Name = "Half-Life Deathmatch",
		Description = "OG deathmatch.",
		Public = true
	},
	{
		Name = "Ricochet",
		Description = "Why?",
		Public = true
	},
	{
		Name = "Team Fortress Classic",
		Description = "Hat simulator: boomer edition.",
		Public = true
	},
	{
		Name = "Counter-Strike 1.6",
		Description = "Classic multiplayer shooter.",
		Public = true
	},
	{
		Name = "Half-Life: Opposing Force Deathmatch",
		Description = "Adrian?",
		Public = true
	},
	{
		Name = "Insurgency",
		Description = "Counter-Strike with extra steps.",
		Public = true
	},
	{
		Name = "Vanilla (Minecraft)",
		Description = "Always runs the most up-to-date version of the game, not including snapshots.",
		Public = false
	},
	{
		Name = "OG Modded (Minecraft)",
		Description = "Normal survival with basic rules, runs with around 50 mods on version 1.12.2.",
		Public = false
	},
	{
		Name = "Unbalanced (Minecraft)",
		Description = "Normal survival with little rules. Runs with around 60 OP mods that were rejected from the other servers. Runs on version 1.12.2. Only runs on beefy PCs!",
		Public = false
	},
	{
		Name = "City Build (Minecraft)",
		Description = "The main goal of this server is to cooperatively build a giant city using various mods to make the process go faster and look nicer. Runs on version 1.12.2.",
		Public = false
	},
	{
		Name = "RLCraft (Minecraft)",
		Description = "Runs the most recent version of the RLCraft modpack. Not recommended for people with low amounts of patience.",
		Public = false
	},
	{
		Name = "Earth (Minecraft)",
		Description = "Runs the 1:1 scale Earth mod along with various other mods with the goal of simply building. All players get admin, some rules are in place to avoid abuse. Runs on version 1.12.2.",
		Public = false
	},
	{
		Name = "SCP: Secret Laboratory",
		Description = "Multiplayer Containment Breach with improved graphics. Server runs various plugins to keep replayability up and repetition down.",
		Public = false
	},
	{
		Name = "Broke Protocol: Online City RPG",
		Description = "Cool indie game that sorta mixes Minecraft with CityRP and GTA Online.",
		Public = false
	},
	{
		Name = "Sven Co-Op",
		Description = "Multiplayer Half-Life. Server can also support some mods such as Crack-Life.",
		Public = false
	},
	{
		Name = "Killing Floor 2",
		Description = "Zombie Survival 2.",
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
	local split = {}
	for i in getsplit do
		table.insert( split, i )
	end
	if split[1] == "!test" then
		message.channel:send( "Lambda Gaming Announcement Bot successfully loaded. Running on Lua 5.3" )
	elseif split[1] == "!opening" then
		if author.id ~= "580873862036717572" then
			message:reply( "Only OP can use this command." )
			return
		end

		local numsplit = tonumber( split[2] )
		if not split[2] or type( numsplit ) ~= "number" then
			message:reply( author.username..", please input a number as the second argument for the opening command." )
			return
		end
		if not servers[numsplit] then
			message:reply( author.username..", your input index number is out of range." )
			return
		end

		local tbl = servers[numsplit]
		local public
		if tbl.Public then
			public = "Yes"
		else
			public = "No"
		end
		message:reply( ">>> @everyone\n__**Server Opening!**__\n\n**Server: **"..tbl.Name.."\n\n**Description: **"..tbl.Description.."\n\n**Is the server public?: **"..public )
	end
end )

io.input( token )
client:run( "Bot "..io.read() )
