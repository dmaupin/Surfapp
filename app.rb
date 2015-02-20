require 'sinatra'
require 'haml'
require 'sass'
require 'httparty'

configure do
  set :scss, {:style => :compressed, :debug_info => false}
end

get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

# get '/' do
#   @product = "Short Description of Product"
#   haml :index, :layout => :default_layout
# end

get '/' do
	# tide via wunderground weather api
	@resp = HTTParty.get('http://api.wunderground.com/api/MYKEY/tide/q/CA/Los_Angeles.json')
		@tide = @resp['tide']['tideSummaryStats'][0]['maxheight']
		@tidelo = @resp['tide']['tideSummaryStats'][0]['minheight']
		@tidehour= @resp['tide']['tideSummary'][0]['date']['hour']
		@tidemin= @resp['tide']['tideSummary'][0]['date']['min']

	# surf data from magic seaweed api
	@resp1 = HTTParty.get('http://magicseaweed.com/api/MYKEY/forecast/?spot_id=282&units=us')
		@swell = @resp1[0]['swell']['maxBreakingHeight']
		@swell1 = @resp1[0]['swell']['minBreakingHeight']
		@wind = @resp1[0]['wind']['compassDirection']
		@temp = @resp1[0]['condition']['temperature']
		# @loctime = @resp1[0]['localTimestamp']

	erb :index
end