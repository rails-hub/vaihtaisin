class Location < ActiveRecord::Base
  has_many :wishes , :through => :locations_wishes
  
  validates :name, :presence => true
end
