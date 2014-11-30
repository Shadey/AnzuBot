fs = require("fs")
irc = require("irc")
#Reads the config file
bot = JSON.parse(fs.readFileSync("config.js","utf8"))
mods = require("./lib/modules")
#Logs the chat by Date
log = (channel,message) ->
	date = new Date()
	console.log("#{date} : #{message}")
	fs.appendFile("#{channel}.txt","#{date} : #{message}\n",(err) ->
		console.log(err) if err
		)

client = new irc.Client(bot.server,bot.nickName,{
	userName: bot.userName,
	realName: bot.realName,
	channels: bot.channel
	})

client.addListener("message", (nick,channel,message) ->
	command= false
	admincommand = false
	command = true if message[0] is "!"
	admincommand = true if message[0] is "$" and bot.admins.indexOf(nick) isnt -1
	if command is true
		cmd = message.slice(1).toLowerCase()
		switch cmd
			when "version" then client.say(channel,"This is version 0.1.0 of AnzuBot")
			when "source" then client.say(channel,"Source can be found here: https://github.com/Shadey/AnzuBot")
			else
				log(channel,message)
	else if admincommand is true
		cmd = message.slice(1).toLowerCase()
		switch cmd
			when "quit" 
				fs.appendFile(bot.logfile,"--------------------\n") 
				client.disconnect("Bye guys")
			else
				log(channel,message)
	else
		mods.title(client,channel,message)
		log(channel,"#{nick} => #{message}")

	)
client.addListener("registered", () ->
	console.log("Connected")
	client.say("NickServ","identify #{bot.NSPassword}")
	)
client.addListener("error", (e) ->
	console.log(e)
	)


