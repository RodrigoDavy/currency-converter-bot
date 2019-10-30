require 'httparty'
require 'json'

class ExchangeRate
	attr_accessor :base_currency, :target_currency

	def initialize(base_currency = "USD", target_currency = "BRL")
		@uri = URI.parse("https://api.exchangeratesapi.io/latest")
		@base_currency = base_currency
		@target_currency = target_currency
	end

	def convert(qty)
		qty * get_exchange_rate()
	end

	def get_exchange_rate()
		response = get_json_response()
		response.dig("rates", @target_currency).to_f
	end

	private

	def get_json_response()
		add_args_to_uri()
		request = HTTParty.get(@uri)
		JSON.parse(request.body)
	end

	def add_args_to_uri()
		args = { base: @base_currency, symbols: @target_currency }
		@uri.query = URI.encode_www_form(args)
	end
	
end


