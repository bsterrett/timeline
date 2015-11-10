class Player < ActiveRecord::Base
  belongs_to :game

  has_many :troops
  has_many :towers
end
