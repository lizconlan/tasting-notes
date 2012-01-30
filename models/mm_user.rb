require 'mongo_mapper'

class MmUser
  include MongoMapper::Document
  
  many :events
  many :scorecards, :in => :scorecard_ids
  
  key :event_ids, Array
  key :scorecard_ids, Array
  
  def hosted_events
    Event.where(:owner_id => self._id).all
  end

  def attended_events
    events.all
  end
  
  def watch_event(event)
    events << event
    self.save
  end
end