require "discordcr"
require "dotenv"
require "http/client"

Dotenv.load

# TODO: Write documentation for `Crystalbot`
module Crystalbot
  VERSION = "0.1.0"

  prefix = ENV["PREFIX"]
  client_id = ENV["CLIENT_ID"]
  client = Discord::Client.new(token: "Bot #{ENV["BOT_TOKEN"]}", client_id: client_id.not_nil!.to_u64)
  cache = Discord::Cache.new(client)
  client.cache = cache

  bot = cache.resolve_user(client.client_id.to_u64)

  client.on_ready do
    puts "#{bot.username} is online!"
  end

  client.on_message_create do |message|
    next if message.author.bot
    next if !message.content.starts_with?(prefix)
    cmd = message.content.gsub(prefix, "")
    puts cmd

    # Commands (I tried to use case/when, but it was causing some issues)

    if cmd.starts_with?("hello")
      client.create_message(message.channel_id, "<@#{message.author.id}> **|** 👋 Hello, #{message.author.username}!")
    end

    if cmd.starts_with?("ping")
      time = Time.utc - message.timestamp
      client.create_message(message.channel_id, "<@#{message.author.id}> **|** 📡 My ping is: `#{time.total_milliseconds.floor}` ms")
    end

    if cmd.starts_with?("avatar")
      command_args = cmd.split(' ')

      user_id = message.mentions && !message.mentions.empty? ? message.mentions[0].id : command_args.size > 1 ? command_args[1] : message.author.id

      begin
        user = cache.resolve_user(user_id.to_u64)

        base_url = "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar}"
        response = HTTP::Client.get(base_url)
        avatar_url = ""
        if response.status_code == 200
          content_type = response.headers["content-type"]
          avatar_url = content_type == "image/png" ? "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar}.png?size=2048" : "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar}.gif?size=2048"

          base_url2 = "https://cdn.discordapp.com/avatars/#{message.author.id}/#{message.author.avatar}"
          response2 = HTTP::Client.get(base_url2)
          avatar_url2 = ""
          if response2.status_code == 200
            content_type2 = response2.headers["content-type"]
            avatar_url2 = content_type2 == "image/png" ? "https://cdn.discordapp.com/avatars/#{message.author.id}/#{message.author.avatar}.png?size=2048" : "https://cdn.discordapp.com/avatars/#{message.author.id}/#{message.author.avatar}.gif?size=2048"
          end

          embed = Discord::Embed.new
          embed.title = "#{user.username}'s Avatar"
          embed.description = "[View it here](#{avatar_url})"
          embed.colour = 0xFF0000 # Hexadecimal color
          embed.image = Discord::EmbedImage.new(url: avatar_url)
          embed.footer = Discord::EmbedFooter.new(text: "Executed by: #{message.author.username}", icon_url: avatar_url2)
        end
        client.create_message(channel_id: message.channel_id, content: "", embed: embed)
      rescue ex : Exception
        client.create_message(message.channel_id, "<@#{message.author.id}> **|** ❌ Please mention a user or provide a valid member ID.")
      end
    end
  end

  client.run
end
