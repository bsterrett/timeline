require 'rails_helper'

describe User do
  it 'cannot be saved without username' do
    user = User.new
    expect{ user.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it 'can be saved with username' do
    user = create(:user, username: 'Ben')
    expect{ user.save }.to_not raise_error
    expect(user.username).to eq('Ben')
  end

  it 'can create a user' do
    user = create(:user)
    expect{ user.create_player }.to change(Player, :count).by(1)
    expect(user.create_player.username).to eq(user.username)
  end
end
