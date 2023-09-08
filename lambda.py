import discord
import feedparser
import json
from datetime import timedelta
from discord.ext import commands

intents = discord.Intents.all()
bot = commands.Bot( command_prefix = "!", intents = intents )
jsonfile = open( "servers.json", "r" )
servers = json.loads( jsonfile.read() )
jsonfile.close()

def ParseSummary( summary ):
	formats = [
		['<div class="bb_h1">', "\n\n**"],
		["</div>", "**"],
		['<ul class="bb_ul">', ""],
		["</ul>", ""],
		["<li>", "\n\t•"],
		["</li>", ""],
		["<br><br>", ""],
		["<br />", ""],
		["<br>", "\n"],
		["&quot;", '"']
	]
	for f in formats:
		summary = summary.replace( f[0], f[1] )
	return summary

def GetAdditionalInfo( *args ):
	if len( args ) >= 2:
		info = ""
		for i in range( 1, len( args ) ):
			info += f" {args[i]}"
		return f"\n\n**Additional Info:**{info}"
	return ""

@bot.event
async def on_ready():
	print( f'Logged in as {bot.user}!' )

@bot.event
async def on_command_error( ctx, error ):
	if isinstance( error, commands.MissingRequiredArgument ):
		await ctx.send( f"Missing argument(s) for {ctx.message.content}", delete_after = 5 )
	if isinstance( error, commands.MissingPermissions ):
		await ctx.send( "You don't have permission to use this command.", delete_after = 5 )

@commands.has_permissions( administrator = True )
@bot.command()
async def opening( ctx, *args ):
	if len( args ) < 1:
		await ctx.send( "Please input the server name as the first argument.", delete_after = 5 )
		return
	if not args[0] in servers:
		await ctx.send( "Server name is invalid.", delete_after = 5 )
		return
	tbl = servers[args[0]]
	available = tbl['Available']
	additional = GetAdditionalInfo( *args )
	content = ""
	if "Content" in tbl:
		content = f"\n\n**Required Content: **<{tbl['Content']}>"
	await ctx.message.delete()
	await ctx.send( f">>> <@&{tbl['Mention']}>\n__**Server Opening!**__\n\n**Server: **{tbl['Name']}\n\n**Description: **{tbl['Description']}\n\n**Availability: **{available}{content}{additional}" )
	await ctx.guild.create_scheduled_event(
		name = "Server Opening",
		description = f"The {tbl['Name']} server is opening.\n\nDescription: {tbl['Description']}\n\nAvailability: {available}{content}{additional}",
		start_time = discord.utils.utcnow() + timedelta( seconds = 5 ),
		end_time = discord.utils.utcnow() + timedelta( minutes = 300 ),
		privacy_level = discord.PrivacyLevel.guild_only,
		entity_type = discord.EntityType.external,
		location = tbl['Name']
	)

@commands.has_permissions( administrator = True )
@bot.command()
async def update( ctx ):
	getrss = feedparser.parse( "https://steamcommunity.com/groups/LambdaG/rss" )
	item = getrss.entries[0]
	embed = discord.Embed(
		title = item.title,
		url = item.link,
		description = ParseSummary( item.summary ),
		color = 0xFF5900
	)
	await ctx.send( embed = embed )
	await ctx.message.delete()

if __name__ == "__main__":
	try:
		token = open( "token.txt", "r" )
		bot.run( token.read() )
	except Exception as e:
		print( f"An error occurred while loading the bot: {e}" )
