require 'rails_helper'

describe MapBaseSpawn do
  before(:all) do
    @map_base_spawn = create(:map_base_spawn)
  end

  it 'should filter by locked' do
    player = create(:player)
    unlocked_map_base_spawn = create(:locked_map_base_spawn, player: player)
    locked_map_base_spawn = create(:unlocked_map_base_spawn, player: player)

    expect(player.map_base_spawns.unlocked).to eq([unlocked_map_base_spawn])
  end

  it 'should filter by unlocked' do
    player = create(:player)
    unlocked_map_base_spawn = create(:locked_map_base_spawn, player: player)
    locked_map_base_spawn = create(:unlocked_map_base_spawn, player: player)

    expect(player.map_base_spawns.locked).to eq([locked_map_base_spawn])
  end

  it 'should have a predicate for locked' do
    expect(@map_base_spawn).to respond_to(:locked?)
    expect(@map_base_spawn).to respond_to(:spawn_locked?)
  end

  it 'should be unlocked after creation' do
    map_base_spawn = create(:player_with_spawns).map_base_spawns.first
    expect(map_base_spawn).to_not be_locked
    expect(map_base_spawn).to_not be_spawn_locked
  end

  context 'when spawning a base' do
    it 'should respond to spawn' do
      expect(@map_base_spawn).to respond_to(:spawn)
    end

    context 'when unlocked' do
      before(:each) do
        @unlocked_map_base_spawn = create(:unlocked_map_base_spawn)
        @base_attributes = { base_type: create(:base_type) }
      end

      after(:each) do
        @unlocked_map_base_spawn.destroy
      end

      it 'should create a base' do
        expect{ @unlocked_map_base_spawn.spawn(@base_attributes) }.to change(Base, :count).by(1)
      end

      it 'should create a base that belongs to its player' do
        base = @unlocked_map_base_spawn.spawn(@base_attributes)
        expect(base.player).to eq(@unlocked_map_base_spawn.player)
      end

      it 'should create a base using its position' do
        base = @unlocked_map_base_spawn.spawn(@base_attributes)
        expect(base.position).to eq(@unlocked_map_base_spawn.position)
      end

      it 'should create a base using its location' do
        base = @unlocked_map_base_spawn.spawn(@base_attributes)
        expect(base.location).to eq(@unlocked_map_base_spawn.location)
      end

      it 'should lock itself' do
        base = @unlocked_map_base_spawn.spawn(@base_attributes)
        expect(@unlocked_map_base_spawn.locked?).to eq(true)
        expect(@unlocked_map_base_spawn.spawn_locked?).to eq(true)
      end
    end

    context 'when locked' do
      before(:each) do
        @locked_map_base_spawn = create(:locked_map_base_spawn)
        @base_attributes = { base_type: create(:base_type) }
      end

      after(:each) do
        @locked_map_base_spawn.destroy
      end

      it 'should raise an error' do
        expect{ @locked_map_base_spawn.spawn(@base_attributes) }.to raise_error(Exceptions::LockedSpawnError)
      end

      it 'should not create a base' do
        expect{ @locked_map_base_spawn.spawn(@base_attributes) rescue nil }.to_not change(Base, :count)
      end
    end
  end

  after(:all) do
    @map_base_spawn.destroy
  end
end
