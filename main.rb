require 'telegram/bot'
require './telegram/generic_answering_bot'
require './exchange_rate'
require 'pry'

@token = ARGV[0] || ''

def run
	@exchange_rate = ExchangeRate.new()
	bot = GenericAnsweringBot.new(Telegram::Bot::Client.new(@token))

	set_strings()
	set_methods()

	bot.add_command_and_response('/start', @start)
	bot.add_command_and_response('/convert', @convert)
	bot.add_command_and_response('/help', @help)

	bot.listen { |chat, message| bot.respond(chat, message) }
end

def set_strings
	@start = "Hi! I'm a Currency Convert bot.
		To see the commands available, write /help"

	@help = "Available commands:
		--------------------------
		/start - Welcome message
		/convert - Convert between currencies
		/help - Shows this message"
end

def set_methods
	@convert = lambda do |args|
		qty = args[0].to_f
		@exchange_rate.base_currency = args[1] unless args[1].nil?
		@exchange_rate.target_currency = args[2] unless args[2].nil?

		@exchange_rate.convert(qty)
	end
end

run()
