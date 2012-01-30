require 'mongo_mapper'

class Event
  include MongoMapper::Document
  
  belongs_to :owner, :class_name => 'MmUser'
  many :attendees, :class_name => 'MmUser', :in => :attendee_ids
  many :drinks, :in => :drink_ids
  
  key :name, String
  key :date, Date
  key :location, String
  key :attendee_ids, Array
  key :drink_ids, Array
  
  def self.reserved_names
    ["add", "edit", "new", "search", "name", "event", "user"]
  end
end