import discord
import feedparser
import json
from datetime import timedelta
from discord import app_commands, Poll
from discord.ext import commands

bot = commands.Bot( command_prefix = "!", intents = discord.Intents.all(), allowed_mentions = discord.AllowedMentions( roles = True, users = True, everyone = True ) )
jsonfile = open( "servers.json", "r" )
servers = json.loads( jsonfile.read() )
jsonfile.close()

pollServers = [
	"CityRP", "Half-Life Universe RP",
	"Various Gamemodes", "Sandbox",
	"SCP: Secret Laboratory", "MC Adventure (2024)",
	"MC Modded 1 (2018)", "MC Modded 2 (2023)",
	"MC Unbalanced 1 (2019)", "MC Unbalanced 2 (2020)"
]

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

@bot.event
async def on_ready():
	sync = await bot.tree.sync()
	print( f'Logged in as {bot.user} and synced {len( sync )} commands!' )

@bot.tree.command( name = "opening", description = "Announce a server opening." )
@app_commands.describe( server = "The server to open" )
@app_commands.default_permissions( permissions = 8 )
async def opening( inter: discord.Interaction, server: str ):
	if not server in servers:
		await inter.response.send_message( "Server name is invalid." )
		return
	tbl = servers[server]
	notes = "Notes" in tbl and f"**Notes: **{tbl['Notes']}" or ""
	content = "Content" in tbl and f"**Required Content: **<{tbl['Content']}>" or ""
	await inter.response.send_message( f">>> <@&1334255663227998289>\n__**Server Opening!**__\n\n**Server: **{tbl['Name']}\n\n**Description: **{tbl['Description']}\n\n{notes}\n\n{content}" )
	await inter.guild.create_scheduled_event(
		name = "Server Opening",
		description = f"The {tbl['Name']} server is opening.\n\nDescription: {tbl['Description']}\n\n{notes}\n\n{content}",
		start_time = discord.utils.utcnow() + timedelta( seconds = 5 ),
		end_time = discord.utils.utcnow() + timedelta( minutes = 300 ),
		privacy_level = discord.PrivacyLevel.guild_only,
		entity_type = discord.EntityType.external,
		location = tbl['Name']
	)

@bot.tree.command( name = "update", description = "Pull latest announcement from Steam group RSS feed." )
@app_commands.default_permissions( permissions = 8 )
async def update( inter: discord.Interaction ):
	getrss = feedparser.parse( "https://steamcommunity.com/groups/LambdaG/rss" )
	item = getrss.entries[0]
	summary = ParseSummary( item.summary )
	if len( summary ) > 4096:
		await inter.response.send_message( f"## __**{item.title}**__\n\nChangelog is too big to be posted here, linking to Steam announcement instead.\n\n{item.link}" )
		return
	embed = discord.Embed(
		title = item.title,
		url = item.link,
		description = summary,
		color = 0xFF5900
	)
	await inter.response.send_message( embed = embed )

@bot.tree.command( name = "openvote", description = "Open server voting." )
@app_commands.describe( day = "The day the server will open" )
@app_commands.describe( time = "The time the server will open" )
@app_commands.default_permissions( permissions = 8 )
async def openvote( inter: discord.Interaction, day: str, time: str ):
	await inter.channel.purge()
	vote = Poll( question = "Vote on this week's server", duration = timedelta( hours = 168 ), multiple = True )
	for server in pollServers:
		vote.add_answer( text = server )
	await inter.response.send_message( f"<@&1334255663227998289>\nVote for the servers you'd like to join this week. Please do not vote if you do not plan on joining. All servers require at least 3 votes to be opened. Ties will be broken by OP.\n\nThe winning server this week will be opened on **{day} @ {time} EST.**", poll = vote )

@bot.tree.command( name = "closevote", description = "Close server voting." )
@app_commands.default_permissions( permissions = 8 )
async def closevote( inter: discord.Interaction ):
	messages = [message async for message in inter.channel.history()]
	await messages[0].end_poll()
	await inter.response.send_message( "Vote closed.", ephemeral = True )

if __name__ == "__main__":
	try:
		token = open( "token.txt", "r" )
		bot.run( token.read() )
	except Exception as e:
		print( f"An error occurred while loading the bot: {e}" )
