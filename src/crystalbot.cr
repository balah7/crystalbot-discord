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

  bot = cache.resolve_user(client_id.to_u64)

  client.on_ready do
    puts "#{bot.username} is online!"
  end

  client.on_message_create do |message|
    next if message.author.bot
    next if !message.content.starts_with?(prefix)
    cmd = message.content.gsub(prefix, "")

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

        embed = Discord::Embed.new
        embed.title = "#{user.username}'s Avatar"
        embed.description = "[View it here](#{avatar_url(user)})"
        embed.colour = random_hexcolor # Hexadecimal color
        embed.image = Discord::EmbedImage.new(url: avatar_url(user))
        embed.footer = Discord::EmbedFooter.new(text: "Executed by: #{message.author.username}", icon_url: avatar_url(message.author))
        client.create_message(channel_id: message.channel_id, content: "", embed: embed)
      rescue ex : Exception
        client.create_message(message.channel_id, "<@#{message.author.id}> **|** ❌ Please mention a user or provide a valid member ID.")
        puts ex.message
      end
    end
  end

  client.run
end

def avatar_url(user : Discord::User) : String
  url = "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar}"
  response = HTTP::Client.get(url)
  if user.avatar && response.status_code == 200
    extension = user.avatar.not_nil!.starts_with?("a_") ? ".gif?size=4096" : ".png?size=4096"
    url + extension
  else
    index = user.discriminator == "0" ? (user.id.to_u64 >> 22) % 6 : user.discriminator.to_i % 5
    "https://cdn.discordapp.com/embed/avatars/#{index}.png?size=4096"
  end
end

def random_hexcolor : UInt32
  r = rand(255).to_s(16).rjust(2, '0')
  g = rand(255).to_s(16).rjust(2, '0')
  b = rand(255).to_s(16).rjust(2, '0')

  "0x#{r}#{g}#{b}"[2..-1].to_i(16).to_u32
end
