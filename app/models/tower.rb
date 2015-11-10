class Tower < ActiveRecord::Base
  belongs_to :player
  belongs_to :tower_type
end
