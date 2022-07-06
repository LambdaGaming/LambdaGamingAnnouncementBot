from discord.ext import commands
import feedparser
import json

bot = commands.Bot( command_prefix = "!" )
jsonfile = open( "servers.json", "r" )
servers = json.loads( jsonfile.read() )
jsonfile.close()

def ParseSummary( summary ):
	formats = [
		['<div class="bb_h1">', "\n**"],
		["</div>", "**"],
		['<ul class="bb_ul">', ""],
		["</ul>", ""],
		["<li>", "\n\t•"],
		["</li>", ""],
		["<br><br>", ""],
		["<br />", ""],
		["<br>", "\n"]
	]
	for f in formats:
		summary = summary.replace( f[0], f[1] )
	return summary

def GetAdditionalInfo( *args ):
	if len( args ) >= 2:
		return f"\n\n**Additional Info: **{args[1]}"
	return ""

@bot.event
async def on_ready():
	print( f'Logged in as {bot.user}!' )

@bot.event
async def on_command_error( ctx, error ):
	if isinstance( error, commands.MissingRequiredArgument ):
		await ctx.send( "Missing argument(s) for " + ctx.message.content )
	if isinstance( error, commands.MissingPermissions ):
		await ctx.send( "You don't have permission to use this command." )

@commands.has_permissions( administrator = True )
@bot.command()
async def opening( ctx, *args ):
	if len( args ) < 1:
		await ctx.message.reply( "Please input the server name as the first argument." )
		return
	if not args[0] in servers:
		await ctx.message.reply( "Server name is invalid." )
		return
	tbl = servers[args[0]]
	public = tbl['Public'] and "Yes" or "No"
	additional = GetAdditionalInfo( *args )
	content = ""
	if "Content" in tbl:
		content = f"\n\n**Required Content: **<{tbl['Content']}>"
	await ctx.channel.purge( limit = 2 )
	await ctx.send( f">>> <@&{tbl['Mention']}>\n__**Server Opening!**__\n\n**Server: **{tbl['Name']}\n\n**Description: **{tbl['Description']}\n\n**Is the server public?: **{public}{content}{additional}" )

@commands.has_permissions( administrator = True )
@bot.command()
async def update( ctx ):
	getrss = feedparser.parse( "https://steamcommunity.com/groups/LambdaG/rss" )
	item = getrss.entries[0]
	await ctx.send( f">>> __**{item.title}**__\n{ParseSummary( item.summary )}" )
	await ctx.message.delete()

if __name__ == "__main__":
	try:
		token = open( "token.txt", "r" )
		bot.run( token.read() )
	except Exception as e:
		print( "An error occurred while loading the bot: " + str( e ) )
