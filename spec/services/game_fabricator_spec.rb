require 'rails_helper'

describe GameFabricator do
  context 'before creating a game' do
    before(:each) do
      @game_fabricator = build(:game_fabricator)
    end

    it 'should not be frozen' do
      expect(@game_fabricator).to_not be_frozen
    end

    context 'when accepting users' do
      it 'allows single user assignment' do
        user = create(:user)
        expect{ @game_fabricator.users << user }.to change(@game_fabricator.users, :count).by(1)
      end

      it 'allows multiple user assignment' do
        users = create_list(:user, 5)
        expect{ @game_fabricator.users.concat(users) }.to change(@game_fabricator.users, :count).by(5)
      end

      it 'can be created with a user' do
        user = create(:user)
        game_fabricator = GameFabricator.new(user)
        expect(game_fabricator.users.count).to be == 1
      end

      it 'can be created with multiple users' do
        users = create_list(:user, 5)
        game_fabricator = GameFabricator.new(users)
        expect(game_fabricator.users.count).to be == 5
      end
    end

    context 'when accepting players' do
      it 'allows single player assignment' do
        player = create(:player)
        expect{ @game_fabricator.players << player }.to change(@game_fabricator.players, :count).by(1)
      end

      it 'allows multiple player assignment' do
        players = create_list(:player, 5)
        expect{ @game_fabricator.players.concat(players) }.to change(@game_fabricator.players, :count).by(5)
      end

      it 'can be created with a player' do
        player = create(:player)
        game_fabricator = GameFabricator.new(player)
        expect(game_fabricator.players.count).to be == 1
      end

      it 'can be created with multiple player' do
        players = create_list(:player, 5)
        game_fabricator = GameFabricator.new(players)
        expect(game_fabricator.players.count).to be == 5
      end
    end

    context 'when accepting a map' do
      it 'allows map assignment' do
        map = create(:map)
        expect{ @game_fabricator.map = map }.to change(@game_fabricator, :map).from(nil).to(map)
      end

      it 'can be created with a map' do
        map = create(:map)
        game_fabricator = GameFabricator.new(map)
        expect(game_fabricator.map).to eq(map)
      end
    end

    context 'when accepting a map' do
      it 'allows map assignment' do
        map = create(:map)
        expect{ @game_fabricator.map = map }.to change(@game_fabricator, :map).from(nil).to(map)
      end

      it 'can be created with a map' do
        map = create(:map)
        game_fabricator = GameFabricator.new(map)
        expect(game_fabricator.map).to eq(map)
      end
    end

    context 'when accepting a match' do
      it 'allows match assignment' do
        match = create(:match)
        expect{ @game_fabricator.match = match }.to change(@game_fabricator, :match).from(nil).to(match)
      end

      it 'can be created with a match' do
        match = create(:match)
        game_fabricator = GameFabricator.new(match)
        expect(game_fabricator.match).to eq(match)
      end
    end

    context 'when accepting multiple arguments at creation' do
      it 'should allow players and users to be assigned' do
        players = create_list(:player, 5)
        users = create_list(:user, 3)
        arguments = (players + users).shuffle
        game_fabricator = GameFabricator.new(arguments)
        expect(game_fabricator.players.count).to be == 5
        expect(game_fabricator.users.count).to be == 3
      end
    end
  end

  context 'when creating a game' do
    it 'should freeze itself' do
      game_fabricator = build(:valid_game_fabricator)
      expect{ game_fabricator.call }.to change(game_fabricator, :frozen?).from(false).to(true)
    end

    it 'does not require players if a match is provided' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to_not raise_error
    end

    context 'it does not require a match and ' do
      it 'does not require players if users are provided' do
        game_fabricator = build(:game_fabricator)
        game_fabricator.map = create(:map, max_players: 2)
        game_fabricator.users = create_list(:user, 2)
        expect{ game_fabricator.call }.to_not raise_error
      end

      it 'does not require users if players are provided' do
        game_fabricator = build(:game_fabricator)
        game_fabricator.map = create(:map, max_players: 2)
        game_fabricator.players = create_list(:player, 2)
        expect{ game_fabricator.call }.to_not raise_error
      end
    end

    it 'should not change the number of users' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to_not change(User, :count)
    end

    it 'should not change the number of maps' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to_not change(Map, :count)
    end

    it 'should not change the number of matches' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to_not change(Match, :count)
    end

    it 'should change the number of games' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to change(Game, :count)
    end

    it 'should change the number of game rulesets'

    it 'should change the number of map base spawns' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to change(MapBaseSpawn, :count).by(2)
    end

    it 'should change the number of map tower spawns' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to change(MapTowerSpawn, :count).by(8)
    end

    it 'should change the number of map troop spawns' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to change(MapTroopSpawn, :count).by(2)
    end

    it 'should change the number of bases' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = map = create(:map, max_players: 2)
      game_fabricator.match = create(:match_with_users, user_count: 2)
      expect{ game_fabricator.call }.to change(Base, :count).by(2)
    end

    it 'should raise an error if no map is provided' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.match = create(:match_with_users, user_count: 6)
      expect{ game_fabricator.call }.to raise_error(GameFabricator::NoMapError)
    end

    it 'should raise an error if no players or users or match are provided' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map)
      expect{ game_fabricator.call }.to raise_error(GameFabricator::NoPlayerError)
    end

    it 'should raise an error if there are too many players for the map' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 5)
      game_fabricator.match = create(:match_with_users, user_count: 6)
      expect{ game_fabricator.call }.to raise_error(GameFabricator::PlayerCountError)
    end

    it 'should raise an error if there are too few players for a map' do
      game_fabricator = build(:game_fabricator)
      game_fabricator.map = create(:map, max_players: 4)
      game_fabricator.match = create(:match_with_users, user_count: 3)
      expect{ game_fabricator.call }.to raise_error(GameFabricator::PlayerCountError)
    end

    it 'should raise an error if provided users dont belong to provided match'
    it 'should raise an error if provided players dont belong to provided match'
    it 'should raise an error if no base spawns are created'
    it 'should raise an error if no tower spawns are created'
    it 'should raise an error if no troop spawns are created'

    context 'when provided with users' do
      it 'should change the number of players'
    end

    context 'when provided with players' do
      it 'should not change the number of players'
    end
  end

  context 'after creating a game' do
    before(:all) do
      @used_game_fabricator = build(:used_game_fabricator)
    end

    it 'should be frozen' do
      expect(@used_game_fabricator).to be_frozen
    end

    context 'when trying to create a second game' do
      it 'should not create a second game' do
        expect{ @used_game_fabricator.call rescue nil }.to_not change(Game, :count)
      end

      it 'should not create more players' do
        expect{ @used_game_fabricator.call rescue nil }.to_not change(Player, :count)
      end

      it 'should not create more bases' do
        expect{ @used_game_fabricator.call rescue nil }.to_not change(Base, :count)
      end

      it 'should not create more map fixtures' do
        expect{ @used_game_fabricator.call rescue nil }.to_not change(MapBaseSpawn, :count)
        expect{ @used_game_fabricator.call rescue nil }.to_not change(MapTowerSpawn, :count)
        expect{ @used_game_fabricator.call rescue nil }.to_not change(MapTroopSpawn, :count)
      end

      it 'should raise an error' do
        expect{ @used_game_fabricator.call }.to raise_error(GameFabricator::DoubleFabricationError)
      end
    end
  end
end
