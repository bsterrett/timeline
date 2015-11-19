require 'rails_helper'

describe Tower do
  it 'cannot be created without a location' do
    tower = build(:tower, location: nil)
    expect{ tower.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  context 'when advancing location' do
    before(:all) do
      @tower = create(:tower)
    end

    after(:all) do
      @tower.destroy
    end

    it 'raises an error' do
      expect{ @tower.advance_location }.to raise_error(Exceptions::ImmobilePieceError)
    end

    it 'does not change location' do
      expect{ @tower.advance_location rescue nil }.to_not change(@tower, :location)
    end
  end

  context 'when filtering by living' do
    before(:all) do
      @player = create(:player_with_game_pieces)
      @player.towers << create_list(:living_tower, 1)
      @player.towers << create_list(:dead_tower, 1)
    end

    after(:all) do
      # TODO shouldn't have to do all this, fixture should do it
      @player.bases.map(&:destroy)
      @player.towers.map(&:destroy)
      @player.troops.map(&:destroy)
      @player.map_base_spawns.map(&:destroy)
      @player.map_tower_spawns.map(&:destroy)
      @player.map_troop_spawns.map(&:destroy)
      @player.destroy
    end

    it 'should have a living named scope' do
      expect(@player.towers).to respond_to(:living)
      expect(Tower).to respond_to(:living)
    end

    it 'should not have any dead towers' do
      expect(@player.towers.living.select { |tower| tower.health <= 0.0 }).to be_empty
    end

    it 'should not have living towers' do
      expect(@player.towers.living.select { |tower| tower.health > 0.0 }.length).to be >= 1
    end
  end

  context 'after creation' do
    before(:all) do
      @tower = create(:tower)
    end

    after(:all) do
      @tower.destroy
    end

    it 'should be living' do
      expect(@tower).to be_living
    end

    it 'should not be dead' do
      expect(@tower).to_not be_dead
    end

    it 'should have less than one current attack' do
      expect(@tower.current_attack).to be < 1
    end

    it 'should have zero current defense' do
      expect(@tower.current_defense).to be == 0
    end

    it 'should have greater than one current range' do
      expect(@tower.current_range).to be > 1
    end

    it 'should have zero current speed' do
      expect(@tower.current_speed).to be == 0
    end
  end

  context 'when leveled up' do
    before(:all) do
      @tower1 = create(:tower, level: 0)
      @tower2 = create(:tower, level: 2)
    end

    after(:all) do
      @tower1.destroy
      @tower2.destroy
    end

    it 'should have increased current attack' do
      expect(@tower2.current_attack).to be > @tower1.current_attack
    end

    it 'should have increased current defense' do
      expect(@tower2.current_defense).to be > @tower1.current_defense
    end

    it 'should have increased current range' do
      expect(@tower2.current_range).to be > @tower1.current_range
    end

    it 'should not have increased current speed' do
      expect(@tower2.current_speed).to be == @tower1.current_speed
    end
  end

  context 'when dead' do
    before(:all) do
      @tower = create(:dead_tower)
    end

    after(:all) do
      @tower.destroy
    end

    it 'should not be living' do
      expect(@tower).to respond_to('living?')
      expect(@tower).to_not be_living
    end

    it 'should be dead' do
      expect(@tower).to respond_to('dead?')
      expect(@tower).to be_dead
    end

    it 'should not attack' do
      tower = create(:tower)
      expect{ @tower.attack(tower) }.to_not change(tower, :health)
    end

    context 'when receiving damage' do
      it 'should not lose health' do
        expect(@tower).to respond_to(:receive_damage)
        expect{ @tower.receive_damage(0.5) }.to_not change(@tower, :health)
      end
    end
  end

  context 'when living' do
    before(:each) do
      @tower = create(:living_tower)
    end

    after(:each) do
      @tower.destroy
    end

    context 'when attacking' do
      it 'can attack' do
        expect(@tower).to respond_to(:attack)
      end

      it 'deals damage' do
        troop = create(:troop, location: @tower.location)
        expect{ @tower.attack troop }.to change(troop, :health)
      end
    end

    context 'when receiving damage' do
      context 'when defense is zero' do
        it 'should reduce health by amount of current attack' do
          expect(@tower.current_defense).to be == 0
          expect{ @tower.receive_damage(0.1) }.to change(@tower, :health).by(-0.1)
        end
      end

      context 'when defense is greater than zero' do
        it 'should reduce health by less than current attack' do
          tower = create(:tower, level: 5)
          expect(tower.current_defense).to be > 0
          expect(tower.health).to be == 1.0
          tower.receive_damage(0.1)
          expect(tower.health).to be > 0.9
        end
      end

      context 'when it is already dead' do
        it 'should not reduce health' do
          tower = create(:dead_tower)
          expect{ tower.receive_damage(0.1) }.to_not change(tower, :health)
        end
      end

      it 'can receive damage' do
        expect(@tower).to respond_to(:receive_damage)
        expect{ @tower.receive_damage(0.5) }.to change(@tower, :health)
      end

      it 'can be killed' do
        @tower.receive_damage(1000.0)
        expect(@tower).to be_dead
      end

      it 'will not have health reduced below zero' do
        expect{ @tower.receive_damage(1000.0) }.to change(@tower, :health).to(0.0)
      end

      it 'reduces incoming damage based on defense' do
        tower = create(:living_tower, level: 5)
        expect(tower.health).to eq(1.0)
        expect(tower.current_defense).to be > 1
        expect{ tower.receive_damage(0.5) }.to change(tower, :health)
        expect(tower.health).to be > 0.6
      end
    end
  end

  context 'when attacking' do
    before(:all) do
      @tower = create(:tower)
    end

    after(:all) do
      @tower.destroy
    end

    it 'cannot attack towers' do
      tower2 = create(:tower)
      expect(@tower.can_attack?(tower2)).to eq(false)
    end

    it 'can attack troops' do
      troop = build(:troop)
      expect(@tower.can_attack?(troop)).to eq(true)
    end

    it 'cannot attack bases' do
      base = create(:base)
      expect(@tower.can_attack?(base)).to eq(false)
    end

    it 'cannot attack out-of-range targets' do
      tower = create(:tower, location: 10)
      troop = create(:troop, location: 0)
      expect(tower).to respond_to(:current_range)
      expect(tower.current_range).to be < (tower.location - troop.location).abs
      expect(tower).to respond_to(:in_range)
      expect(tower.in_range([troop])).to be_empty
    end

    it 'can attack in-range targets'

    context 'receives actual damage dealt' do
      it 'when target has zero defense'
      it 'when target has nonzero defense'
      it 'when the target is killed'
      it 'when more damage is applied than the targets health'
    end
  end
end
