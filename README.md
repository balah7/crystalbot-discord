# Crystalbot - Discord Bot in Crystal

Crystalbot is a simple Discord bot written in Crystal, using the Discordcr shard. It can perform basic tasks such as responding to messages, checking the bot's ping, and fetching user avatars.

## Prerequisites

Before you start using Crystalbot, you'll need to set up a few environment variables. Create a `.env` file in the root directory of your project and add the following variables:

- `BOT_TOKEN`: Your [Discord bot](https://discord.com/developers/applications) token.
- `CLIENT_ID`: Your Discord bot's client ID.
- `PREFIX`: The bot's command prefix.

Use the provided `.env.example` file as a template to define these variables.

## Installation

1. Clone this repository or download the source code.
2. Install Crystal (if you haven't already): [Crystal Installation Guide](https://crystal-lang.org/install/).
3. Run the following commands to install dependencies and start the bot:

```bash
shards install
crystal src/crystalbot.cr
```

The bot should now be running, and you should see a message in your terminal indicating that it's online.

## Usage

Crystalbot responds to specific commands. By default, it listens for commands with the defined prefix. The available commands are:

- `hello`: Greet the user who invoked the command.
- `ping`: Display the bot's ping.
- `avatar`: Show the user's or mentioned user's avatar.

## Advanced Configuration

The code supports more advanced features like fetching user avatars, handling command arguments, and sending rich embeds. If you want to extend or customize this bot, you can explore the Crystal and Discordcr documentation.

## Author

- [Balah7](https://github.com/balah7)

Made with ❤️ by Balah7 🍬
