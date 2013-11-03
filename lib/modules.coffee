cheerio = require("cheerio")
request  = require("request")
exports.title = (client,channel,message) ->
	for i in message.split(" ")
		request(i,(e,res,body) ->
			if not e and res.statusCode is 200
				$ = cheerio.load(body)
				title = $("head").find("title").text()
				client.say(channel,title)
			)