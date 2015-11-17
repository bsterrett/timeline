require 'rails_helper'

describe MapTowerSpawn do
  before(:all) do
    @map_tower_spawn = create(:map_tower_spawn)
  end

  it 'should filter by locked' do
    player = create(:player)
    unlocked_map_tower_spawn = create(:locked_map_tower_spawn, player: player)
    locked_map_tower_spawn = create(:unlocked_map_tower_spawn, player: player)

    expect(player.map_tower_spawns.unlocked).to eq([unlocked_map_tower_spawn])
  end

  it 'should filter by unlocked' do
    player = create(:player)
    unlocked_map_tower_spawn = create(:locked_map_tower_spawn, player: player)
    locked_map_tower_spawn = create(:unlocked_map_tower_spawn, player: player)

    expect(player.map_tower_spawns.locked).to eq([locked_map_tower_spawn])
  end

  it 'should have a predicate for locked' do
    expect(@map_tower_spawn).to respond_to(:locked?)
    expect(@map_tower_spawn).to respond_to(:spawn_locked?)
  end

  it 'should be unlocked after creation' do
    map_tower_spawn = create(:player_with_spawns).map_tower_spawns.first
    expect(map_tower_spawn).to_not be_locked
    expect(map_tower_spawn).to_not be_spawn_locked
  end

  context 'when spawning a tower' do
    it 'should respond to spawn' do
      expect(@map_tower_spawn).to respond_to(:spawn)
    end

    context 'when unlocked' do
      before(:each) do
        @unlocked_map_tower_spawn = create(:unlocked_map_tower_spawn)
        @tower_attributes = { tower_type: create(:tower_type) }
      end

      after(:each) do
        @unlocked_map_tower_spawn.destroy
      end

      it 'should create a tower' do
        expect{ @unlocked_map_tower_spawn.spawn(@tower_attributes) }.to change(Tower, :count).by(1)
      end

      it 'should create a tower that belongs to its player' do
        tower = @unlocked_map_tower_spawn.spawn(@tower_attributes)
        expect(tower.player).to eq(@unlocked_map_tower_spawn.player)
      end

      it 'should create a tower using its position' do
        tower = @unlocked_map_tower_spawn.spawn(@tower_attributes)
        expect(tower.position).to eq(@unlocked_map_tower_spawn.position)
      end

      it 'should create a tower using its location' do
        tower = @unlocked_map_tower_spawn.spawn(@tower_attributes)
        expect(tower.location).to eq(@unlocked_map_tower_spawn.location)
      end

      it 'should lock itself' do
        tower = @unlocked_map_tower_spawn.spawn(@tower_attributes)
        expect(@unlocked_map_tower_spawn.locked?).to eq(true)
        expect(@unlocked_map_tower_spawn.spawn_locked?).to eq(true)
      end
    end

    context 'when locked' do
      before(:each) do
        @locked_map_tower_spawn = create(:locked_map_tower_spawn)
        @tower_attributes = { tower_type: create(:tower_type) }
      end

      after(:each) do
        @locked_map_tower_spawn.destroy
      end

      it 'should raise an error' do
        expect{ @locked_map_tower_spawn.spawn(@tower_attributes) }.to raise_error(Exceptions::LockedSpawnError)
      end

      it 'should not create a tower' do
        expect{ @locked_map_tower_spawn.spawn(@tower_attributes) rescue nil }.to_not change(Tower, :count)
      end
    end
  end

  after(:all) do
    @map_tower_spawn.destroy
  end
end
