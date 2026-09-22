import fluxer
import json
from urllib import request
from markdownify import markdownify

bot = fluxer.Bot( command_prefix = "!", intents = fluxer.Intents.GUILDS | fluxer.Intents.GUILD_MESSAGES )
jsonfile = open( "servers.json", "r" )
servers = json.loads( jsonfile.read() )
jsonfile.close()

@bot.event
async def on_ready():
	print( f'Logged in as {bot.user.username}!' )

@bot.command()
async def opening( ctx, server: str ):
	await ctx.delete()
	if not server in servers:
		await ctx.reply( "Server name is invalid." )
		return
	tbl = servers[server]
	notes = "Notes" in tbl and f"**Notes: **{tbl['Notes']}" or ""
	content = "Content" in tbl and f"**Required Content: **<{tbl['Content']}>" or ""
	await ctx.send( f">>> <@&1516679466342940672>\n__**Server Opening!**__\n\n**Server: **{tbl['Name']}\n\n**Description: **{tbl['Description']}\n\n{notes}\n\n{content}" )

@bot.command()
async def update( ctx, role: fluxer.Role = None ):
	await ctx.delete()
	with request.urlopen( "https://lambdagaming.github.io/data/news.json" ) as url:
		news = json.loads( url.read().decode() )
	item = news[0]
	info = markdownify( item['info'] )
	link = f"https://lambdagaming.github.io/news?id={len( news )}"
	mention = role if role is not None else ""
	if len( info ) > 4096:
		await ctx.send( f"{mention}## __**{item['title']}**__\n\nAnnouncement is too big to be posted here, linking to website instead.\n\n{link}" )
		return
	embed = fluxer.Embed(
		title = item['title'],
		url = link,
		description = info,
		color = 0xFF5900
	)
	await ctx.send( mention, embed = embed )

if __name__ == "__main__":
	try:
		token = open( "token_flux.txt", "r" )
		bot.run( token.read().strip( "\n" ) )
	except Exception as e:
		print( f"An error occurred while loading the bot: {e}" )
