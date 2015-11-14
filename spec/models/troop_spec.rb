require 'rails_helper'

describe Troop do
  it 'should be living after creation' do
    troop = Troop.new
    expect(troop).to be_living
  end
end
