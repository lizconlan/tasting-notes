require "digest/sha1"
require "mongo_mapper"
require "sinatra-authentication"
require "rack-flash"

require './lib/brew_db'
require './models/event'
require './models/mm_user'
require './models/drink'
require './models/scorecard'

MONGO_URL = ENV['MONGOHQ_URL'] || YAML::load(File.read("config/secrets.yml"))[:mongo]
env = {}
MongoMapper.config = { env => {'uri' => MONGO_URL} }
MongoMapper.connect(env)

enable :sessions
use Rack::Flash
use Rack::Session::Cookie, :secret => ENV['cookie_secret'] || YAML::load(File.read("config/secrets.yml"))[:cookie]

get "/" do
  if logged_in?
    redirect "/events"
  else
    haml "= render_login_logout"
  end
end

get "/events" do
  q = params[:q]
  if q and q.length > 1
    @results = Event.find_all_by_name(/#{q}/)
  end
  haml :events
end

get "/events/add" do
  haml :add_event
end

post "/events/add" do
  name = params["name"]
  loc = params["location"]
  date = params["date"]
  
  error = nil
  if name.nil? or name.strip.empty?
    error = "<li>Must supply a name for the event</li>"
  else
    if Event.reserved_names.include?(name) or Event.find_by_name(name.strip)
      error = "<li>Sorry, an event of that name has already been set up</li>"
    end
  end
  if loc.nil? or loc.strip.empty?
    error = "#{error}<li>Must supply a location for the event</li>"
  end
  flash[:error] = error
  
  unless error
    event = Event.new({:name => name, :location => loc, :date => date})
    event.owner = current_user
    event.save
    redirect "/events"
  end
  haml :add_event
end

get "/events/edit/:id/find_beer" do
  haml :find_beer
end

post "/events/edit/:id/find_beer" do
  beer_api = BrewDB.new
  @results = beer_api.find_brewery_by_name(params[:brewery])
  haml :find_beer
end

get "/events/edit/:id/find_beer/:brewery_id" do
  beer_api = BrewDB.new
  @brewery_info = beer_api.get_brewery_info(params[:brewery_id])
  @beers = beer_api.list_beers_by_brewery_id(params[:brewery_id])
  haml :list_beer
end

post "/events/edit/:id/_add_beer" do
  beer_ids = []
  params.keys.each do |name|
    if name =~ /^beer_(.*)/
      beer_ids << $1 
    end
  end
  unless beer_ids.empty?
    beer_api = BrewDB.new
    @event = Event.find(params[:id])
    beers = beer_api.list_beers_by_brewery_id(params[:brewery_id])
    beers.each do |beer|
      if beer_ids.include?(beer["id"])
        drink = Drink.find_or_create_by_drink_brewerydb_id(beer["id"])
        unless drink.brewery_name
          drink.brewery_name = params[:brewery_name]
          drink.brewery_brewerydb_id = params[:brewery_id]
          drink.drink_brewerydb_id = beer["id"]
          drink.name = beer["name"]
          drink.abv = beer["metadata"]["abv"] if beer["metadata"]["abv"] and beer["metadata"]["abv"] != ""
          drink.notes = beer["description"]
          drink.save
        end
        @event.drinks << drink unless @event.drinks.include?(drink)
      end
    end
    @event.save
  end
  redirect "/events/edit/#{@event.id}"
end

get "/events/edit/:id" do
  @event = Event.find(params[:id])
  haml :edit_event
end

get "/events/:id/watch" do
  event = Event.find(params[:id])
  current_user.watch_event(event)
  event.attendee_ids << current_user.id
  event.save
  redirect "/events"
end

get "/event/:id" do
  @event = Event.find(params[:id])
  
  if current_user.events.include?(@event)
    @scorecard = Scorecard.find_by_mm_user_id_and_event_id(current_user.id, @event.id)
    if @scorecard
      @scorecard.update_card()
    else
      @scorecard = Scorecard.new(current_user, @event)
    end
  end
  haml :view_event
end