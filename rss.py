# Python script to get the steam group RSS feed since it's easier doing it here than in lua

import requests
url = requests.get( "https://steamcommunity.com/groups/LambdaG/rss" )
xml = open( "temp.xml", "wb" )
xml.write( url.text.encode( "utf8" ) ) # Has to be unicode because of the lambdas
xml.close()
url.close()
