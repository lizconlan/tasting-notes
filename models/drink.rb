require 'mongo_mapper'

class Drink
  include MongoMapper::Document
  
  key :brewery_name, String
  key :brewery_brewerydb_id, String
  key :drink_brewerydb_id, String
  key :name, String
  key :abv, String
  key :notes, String
end