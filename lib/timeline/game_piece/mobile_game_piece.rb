module MobileGamePiece
  include GamePiece

  def advance_location
    decrement!(:location) unless dead? or self.location == 0
  end
end
