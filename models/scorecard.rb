require 'mongo_mapper'

class Scorecard
  include MongoMapper::Document
  
  belongs_to :mm_user
  belongs_to :event
  many :ratings, :in => :rating_ids
  
  key :rating_ids, Array
  
  def initialize(user, event)
    self.mm_user = user
    self.event = event
    event.drinks.each do |drink|
      rating = Rating.new
      rating.scorecard = self
      rating.drink = drink
      rating.save
      self.ratings << rating
    end
    self.save
  end
  
  def update_card
    event.drinks.each do |drink|
      unless Rating.find_by_scorecard_id_and_drink_id(self.id, drink.id)
        rating = Rating.new
        rating.scorecard = self
        rating.drink = drink
        self.ratings << rating
      end
    end
  end
end

class Rating
  include MongoMapper::Document
  belongs_to :scorecard
  belongs_to :drink
  
  key :notes, String
  key :score, Float
end