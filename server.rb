require 'bundler'
Bundler.require(:default)
Dotenv.load

require 'sinatra'
require './lib/location.rb'
require './routers/base_router.rb'

get '/' do
  # Get the locations
  set = params.fetch('set', 'subway')
  mode = params.fetch('mode', 'dev')
  locations = fetch_locations(set, mode)

  # Initialize the router
  router_type = params.fetch('router', 'naive')
  load "./routers/#{router_type}_router.rb"
  router = Object.const_get("#{router_type.capitalize}Router").new(locations)

  router.route
  route_info = router.route_info

  @minutes = (route_info[:drive_time] / 60).floor
  @seconds = route_info[:drive_time] % 60
  @waypoints = route_info[:waypoints]

  erb :index
end

def fetch_locations(set, mode)
  location_rows = CSV.read("address_sets/#{set}_#{mode}_sample_matrix.csv", {:headers => true, :header_converters => :symbol}).map(&:to_hash)
  location_rows.map do |row|
    Location.new(row)
  end
end
