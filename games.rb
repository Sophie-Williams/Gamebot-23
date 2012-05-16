# -*- coding: utf-8 -*-
require 'fileutils'
require 'cinch'

class GamesContoller
 include Cinch::Plugin

  match /play (.*)/, method: :play
  match /gamelist/, method: :gamelist
  match /no (.*)/, method: :no
  match /addgame (.*)/, method: :addgame
  match /adminadd (.*)/, method: :adminAdd
  match /setup/, method: :setup
  match /help/, method: :help
  
  def initialize(*args)
	super
	@adminlist = if File.exists?('adminlist')
                            File.open('adminlist') do|file|
                              Marshal.load(file)
                            end
                          else
                            ["gporter"]
                          end
	@gamelist = if File.exists?('gamelist')
							File.open('gamelist') do|file|
								Marshal.load(file)
							end
						else
							{"hon" => [], "midwars" => [], "lol" => [], "CSS" => [], "diablo3" => [], "tf2" => [], "dota" => []}
						end	
  end  


  def setup(m)
    if (m.user.nick)!="gporter"
      return
    end
	@adminlist = if File.exists?('adminlist')
                            File.open('adminlist') do|file|
                              Marshal.load(file)
							  User(m.user.nick).send "adminlist loaded"
                            end
                          else
                            User(m.user.nick).send "No admin file found"
							["gporter"]
                          end
	@gamelist = if File.exists?('gamelist')
							File.open('gamelist') do|file|
								Marshal.load(file)
								User(m.user.nick).send "Gamelist loaded"
							end
						else
							User(m.user.nick).send "No game file found"
							{"hon" => [], "midwars" => [], "lol" => [], "CSS" => [], "diablo3" => [], "tf2" => [], "dota" => []}
						end	
	User(m.user.nick).send "Setup Complete"
  end

	def help(m)
		User(m.user.nick).send "Command List:"
		User(m.user.nick).send "!play gameName, to sign up to play a game"
		User(m.user.nick).send "!no gameName, to remove sign on from game"
		User(m.user.nick).send "!gamelist, view all game listings and players"
	end

  def play(m, args)
	
	if @gamelist.has_key?("#{args}")
		if !@gamelist["#{args}"].include?(m.user.nick) then
			@gamelist["#{args}"] << m.user.nick
			@gamelist["#{args}"].each{|e| User(e).send "#{args}: " + @gamelist["#{args}"].inspect}
		else
			User(m.user.nick).send "Already in for #{args}"
		end
	else
		User(m.user.nick).send "Not a valid Game"
	end
  end
  
  def gamelist(m)
	User(m.user.nick).send @gamelist
  end
  
  
  def no(m, args)
	if @gamelist.has_key?("#{args}")
		if @gamelist["#{args}"].include?(m.user.nick) then
			@gamelist["#{args}"].delete (m.user.nick)
		end
		@gamelist["#{args}"].each{|e| User(e).send "#{args}: " + @gamelist["#{args}"].inspect}
	else
		User(m.user.nick).send "Not a valid Game"
	end
  end
	
  def addgame(m, args)
    if !@adminlist.include?(m.user.nick)
      return
    end
	
	
	@gamelist["#{args}"] = []
	
	User(m.user.nick).send "Added to gamelist"
  end
	
	
   def adminAdd(m, args)
    if !@adminlist.include?(m.user.nick)
      return
    end
     @adminlist << "#{args}"
	
	User(m.user.nick).send "Added to admin list"
	
   end


end