require 'rails_helper'

describe Troop do
  it 'cannot be created without a location' do
    troop = build(:troop, location: nil)
    expect{ troop.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  context 'when filtering by living' do
    before(:all) do
      @player = create(:player_with_game_pieces)
      @player.troops << create_list(:living_troop, 5)
      @player.troops << create_list(:dead_troop, 5)
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
      expect(@player.troops).to respond_to(:living)
      expect(Troop).to respond_to(:living)
    end

    it 'should not have any dead troops' do
      expect(@player.troops.living.select { |troop| troop.health <= 0.0 }).to be_empty
    end

    it 'should not have living troops' do
      expect(@player.troops.living.select { |troop| troop.health > 0.0 }.length).to be >= 5
    end
  end

  context 'after creation' do
    before(:all) do
      @troop = create(:troop)
    end

    after(:all) do
      @troop.destroy
    end

    it 'should be living' do
      expect(@troop).to be_living
    end

    it 'should not be dead' do
      expect(@troop).to_not be_dead
    end

    it 'should have less than 1 current attack' do
      expect(@troop.current_attack).to be < 1
    end

    it 'should have 0 current defense' do
      expect(@troop.current_defense).to be == 0
    end

    it 'should have 1 current range' do
      expect(@troop.current_range).to be == 1
    end

    it 'should have 1 current speed' do
      expect(@troop.current_speed).to be == 1
    end
  end

  context 'when leveled up' do
    before(:all) do
      @troop1 = create(:troop, level: 0)
      @troop2 = create(:troop, level: 2)
    end

    after(:all) do
      @troop1.destroy
      @troop2.destroy
    end

    it 'should have increased current attack' do
      expect(@troop2.current_attack).to be > @troop1.current_attack
    end

    it 'should have increased current defense' do
      expect(@troop2.current_defense).to be > @troop1.current_defense
    end

    it 'should not have increased current range' do
      expect(@troop2.current_range).to be == @troop1.current_range
    end

    it 'should not have increased current speed' do
      expect(@troop2.current_speed).to be == @troop1.current_speed
    end
  end

  context 'when dead' do
    before(:all) do
      @troop = create(:dead_troop)
    end

    after(:all) do
      @troop.destroy
    end

    it 'should not be living' do
      expect(@troop).to respond_to('living?')
      expect(@troop).to_not be_living
    end

    it 'should be dead' do
      expect(@troop).to respond_to('dead?')
      expect(@troop).to be_dead
    end

    it 'should not attack' do
      tower = create(:tower)
      expect{ @troop.attack(tower) }.to_not change(tower, :health)
    end

    context 'when advancing location' do
      it 'should not change location' do
        troop = create(:dead_troop, location: 10)
        expect(troop).to respond_to(:advance_location)
        expect{ troop.advance_location }.to_not change(troop, :location)
      end
    end

    context 'when receiving damage' do
      it 'should not lose health' do
        expect(@troop).to respond_to(:receive_damage)
        expect{ @troop.receive_damage(0.5) }.to_not change(@troop, :health)
      end
    end
  end

  context 'when living' do
    before(:each) do
      @troop = create(:living_troop)
    end

    after(:each) do
      @troop.destroy
    end

    context 'when attacking' do
      it 'can attack' do
        expect(@troop).to respond_to(:attack)
      end

      it 'deals damage' do
        tower = create(:tower, location: @troop.location)
        expect{ @troop.attack tower }.to change(tower, :health)
      end
    end

    context 'when receiving damage' do
      context 'when defense is zero' do
        it 'should reduce health by amount of current attack' do
          expect(@troop.current_defense).to be == 0
          expect{ @troop.receive_damage(0.1) }.to change(@troop, :health).by(-0.1)
        end
      end

      context 'when defense is greater than zero' do
        it 'should reduce health by less than current attack' do
          troop = create(:troop, level: 5)
          expect(troop.current_defense).to be > 0
          expect(troop.health).to be == 1.0
          troop.receive_damage(0.1)
          expect(troop.health).to be > 0.9
        end
      end

      context 'when it is already dead' do
        it 'should not reduce health' do
          troop = create(:dead_troop)
          expect{ troop.receive_damage(0.1) }.to_not change(troop, :health)
        end
      end

      it 'can receive damage' do
        expect(@troop).to respond_to(:receive_damage)
        expect{ @troop.receive_damage(0.5) }.to change(@troop, :health)
      end

      it 'can be killed' do
        @troop.receive_damage(1000.0)
        expect(@troop).to be_dead
      end

      it 'will not have health reduced below zero' do
        expect{ @troop.receive_damage(1000.0) }.to change(@troop, :health).to(0.0)
      end

      it 'reduces incoming damage based on defense' do
        troop = create(:living_troop, level: 5)
        expect(troop.health).to eq(1.0)
        expect(troop.current_defense).to be > 1
        expect{ troop.receive_damage(0.5) }.to change(troop, :health)
        expect(troop.health).to be > 0.6
      end
    end

    context 'when advancing location' do
      context 'when at the end of the map' do
        it 'should not change location' do
          troop = create(:living_troop, location: 0)
          expect(troop).to respond_to(:advance_location)
          expect{ troop.advance_location }.to_not change(troop, :location)
        end
      end

      context 'when not at the end of the map' do
        it 'should change location' do
          troop = create(:living_troop, location: 10)
          expect(troop).to respond_to(:advance_location)
          expect{ troop.advance_location }.to change(troop, :location)
        end

        it 'should change location by its current speed' do
          troop = create(:living_troop, location: 10)
          expect(troop).to respond_to(:advance_location)
          expect{ troop.advance_location }.to change(troop, :location).by(-1 * troop.current_speed)
        end
      end
    end
  end

  context 'when attacking' do
    before(:all) do
      @troop = create(:troop)
    end

    after(:all) do
      @troop.destroy
    end

    it 'cannot attack troops' do
      troop2 = create(:troop)
      expect(@troop.can_attack?(troop2)).to eq(false)
    end

    it 'cannot attack towers' do
      tower = build(:tower)
      expect(@troop.can_attack?(tower)).to eq(false)
    end

    it 'can attack bases' do
      base = create(:base)
      expect(@troop.can_attack?(base)).to eq(true)
    end

    it 'cannot attack out-of-range targets' do
      troop = create(:troop, location: 10)
      base = create(:base, location: 0)
      expect(troop).to respond_to(:current_range)
      expect(troop.current_range).to be < (troop.location - base.location).abs
      expect(troop).to respond_to(:in_range)
      expect(troop.in_range([base])).to be_empty
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
