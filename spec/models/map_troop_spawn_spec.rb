require 'rails_helper'

describe MapTroopSpawn do
  before(:all) do
    @map_troop_spawn = create(:map_troop_spawn)
  end

  it 'should filter by locked' do
    player = create(:player)
    unlocked_map_troop_spawn = create(:locked_map_troop_spawn, player: player)
    locked_map_troop_spawn = create(:unlocked_map_troop_spawn, player: player)

    expect(player.map_troop_spawns.unlocked).to eq([unlocked_map_troop_spawn])
  end

  it 'should filter by unlocked' do
    player = create(:player)
    unlocked_map_troop_spawn = create(:locked_map_troop_spawn, player: player)
    locked_map_troop_spawn = create(:unlocked_map_troop_spawn, player: player)

    expect(player.map_troop_spawns.locked).to eq([locked_map_troop_spawn])
  end

  it 'should have a predicate for locked' do
    expect(@map_troop_spawn).to respond_to(:locked?)
    expect(@map_troop_spawn).to respond_to(:spawn_locked?)
  end

  it 'should be unlocked after creation' do
    map_troop_spawn = create(:player_with_spawns).map_troop_spawns.first
    expect(map_troop_spawn).to_not be_locked
    expect(map_troop_spawn).to_not be_spawn_locked
  end

  context 'when spawning a troop' do
    it 'should respond to spawn' do
      expect(@map_troop_spawn).to respond_to(:spawn)
    end

    context 'when unlocked' do
      before(:each) do
        @unlocked_map_troop_spawn = create(:unlocked_map_troop_spawn)
        @troop_attributes = { troop_type: create(:troop_type) }
      end

      after(:each) do
        @unlocked_map_troop_spawn.destroy
      end

      it 'should create a troop' do
        expect{ @unlocked_map_troop_spawn.spawn(@troop_attributes) }.to change(Troop, :count).by(1)
      end

      it 'should create a troop that belongs to its player' do
        troop = @unlocked_map_troop_spawn.spawn(@troop_attributes)
        expect(troop.player).to eq(@unlocked_map_troop_spawn.player)
      end

      it 'should create a troop using its location' do
        troop = @unlocked_map_troop_spawn.spawn(@troop_attributes)
        expect(troop.location).to eq(@unlocked_map_troop_spawn.location)
      end

      it 'should not lock itself' do
        troop = @unlocked_map_troop_spawn.spawn(@troop_attributes)
        expect(@unlocked_map_troop_spawn.locked?).to eq(false)
        expect(@unlocked_map_troop_spawn.spawn_locked?).to eq(false)
      end
    end

    context 'when locked' do
      before(:each) do
        @locked_map_troop_spawn = create(:locked_map_troop_spawn)
        @troop_attributes = { troop_type: create(:troop_type) }
      end

      after(:each) do
        @locked_map_troop_spawn.destroy
      end

      it 'should raise an error' do
        expect{ @locked_map_troop_spawn.spawn(@troop_attributes) }.to raise_error(Exceptions::LockedSpawnError)
      end

      it 'should not create a troop' do
        expect{ @locked_map_troop_spawn.spawn(@troop_attributes) rescue nil }.to_not change(Troop, :count)
      end
    end
  end

  after(:all) do
    @map_troop_spawn.destroy
  end
end
