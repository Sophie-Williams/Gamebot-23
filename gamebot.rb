require 'cinch'
$LOAD_PATH << '.'
require 'games.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.netsoc.tcd.ie"
    c.nick     = "gamesbot"
    c.channels = ["#gamesbot", "#sc2"]
    c.plugins.plugins = [GamesContoller]
  end
  


  on :message, "hello" do |m|
    User(m.user.nick).send "Hello, World"
  end
end

bot.start