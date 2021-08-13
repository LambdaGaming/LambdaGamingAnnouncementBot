import requests

# Python script to get the steam group RSS feed since it's easier doing it here than in lua
try:
	url = requests.get( "https://steamcommunity.com/groups/LambdaG/rss" )
except Exception as e:
	print( "ERROR: Something went wrong while fetching the RSS feed. " + str( e ) )
else:
	xml = url.text
	print( xml.encode( "ascii", "ignore" ).decode( "ascii" ) ) # Ignore any unicode characters since they cause problems and aren't needed anyway
	url.close()
