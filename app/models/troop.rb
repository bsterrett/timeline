class Troop < ActiveRecord::Base
  belongs_to :player
  has_one :troop_type
end
