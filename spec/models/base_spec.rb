require 'rails_helper'

describe Base do
  it 'cannot be created without a location' do
    base = build(:base, location: nil)
    expect{ base.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  context 'when advancing location' do
    before(:all) do
      @base = create(:base)
    end

    after(:all) do
      @base.destroy
    end

    it 'raises an error' do
      expect{ @base.advance_location }.to raise_error(Exceptions::ImmobilePieceError)
    end

    it 'does not change location' do
      expect{ @base.advance_location rescue nil }.to_not change(@base, :location)
    end
  end

  context 'when filtering by living' do
    before(:all) do
      @player = create(:player_with_game_pieces)
      @player.bases << create_list(:living_base, 1)
      @player.bases << create_list(:dead_base, 1)
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
      expect(@player.bases).to respond_to(:living)
      expect(Base).to respond_to(:living)
    end

    it 'should not have any dead bases' do
      expect(@player.bases.living.select { |base| base.health <= 0.0 }).to be_empty
    end

    it 'should not have living bases' do
      expect(@player.bases.living.select { |base| base.health > 0.0 }.length).to be >= 1
    end
  end

  context 'after creation' do
    before(:all) do
      @base = create(:base)
    end

    after(:all) do
      @base.destroy
    end

    it 'should be living' do
      expect(@base).to be_living
    end

    it 'should not be dead' do
      expect(@base).to_not be_dead
    end

    it 'should have less than one current attack' do
      expect(@base.current_attack).to be < 1
    end

    it 'should have zero current defense' do
      expect(@base.current_defense).to be == 0
    end

    it 'should have greater than one current range' do
      expect(@base.current_range).to be > 1
    end

    it 'should have zero current speed' do
      expect(@base.current_speed).to be == 0
    end
  end

  context 'when leveled up' do
    before(:all) do
      @base1 = create(:base, level: 0)
      @base2 = create(:base, level: 2)
    end

    after(:all) do
      @base1.destroy
      @base2.destroy
    end

    it 'should have increased current attack' do
      expect(@base2.current_attack).to be > @base1.current_attack
    end

    it 'should have increased current defense' do
      expect(@base2.current_defense).to be > @base1.current_defense
    end

    it 'should have increased current range' do
      expect(@base2.current_range).to be > @base1.current_range
    end

    it 'should not have increased current speed' do
      expect(@base2.current_speed).to be == @base1.current_speed
    end
  end

  context 'when dead' do
    before(:all) do
      @base = create(:dead_base)
    end

    after(:all) do
      @base.destroy
    end

    it 'should not be living' do
      expect(@base).to respond_to('living?')
      expect(@base).to_not be_living
    end

    it 'should be dead' do
      expect(@base).to respond_to('dead?')
      expect(@base).to be_dead
    end

    it 'should not attack' do
      base = create(:base)
      expect{ @base.attack(base) }.to_not change(base, :health)
    end

    context 'when receiving damage' do
      it 'should not lose health' do
        expect(@base).to respond_to(:receive_damage)
        expect{ @base.receive_damage(0.5) }.to_not change(@base, :health)
      end
    end
  end

  context 'when living' do
    before(:each) do
      @base = create(:living_base)
    end

    after(:each) do
      @base.destroy
    end

    context 'when attacking' do
      it 'can attack' do
        expect(@base).to respond_to(:attack)
      end

      it 'deals damage' do
        troop = create(:troop, location: @base.location)
        expect{ @base.attack troop }.to change(troop, :health)
      end
    end

    context 'when receiving damage' do
      context 'when defense is zero' do
        it 'should reduce health by amount of current attack' do
          expect(@base.current_defense).to be == 0
          expect{ @base.receive_damage(0.1) }.to change(@base, :health).by(-0.1)
        end
      end

      context 'when defense is greater than zero' do
        it 'should reduce health by less than current attack' do
          base = create(:base, level: 5)
          expect(base.current_defense).to be > 0
          expect(base.health).to be == 1.0
          base.receive_damage(0.1)
          expect(base.health).to be > 0.9
        end
      end

      context 'when it is already dead' do
        it 'should not reduce health' do
          base = create(:dead_base)
          expect{ base.receive_damage(0.1) }.to_not change(base, :health)
        end
      end

      it 'can receive damage' do
        expect(@base).to respond_to(:receive_damage)
        expect{ @base.receive_damage(0.5) }.to change(@base, :health)
      end

      it 'can be killed' do
        @base.receive_damage(1000.0)
        expect(@base).to be_dead
      end

      it 'will not have health reduced below zero' do
        expect{ @base.receive_damage(1000.0) }.to change(@base, :health).to(0.0)
      end

      it 'reduces incoming damage based on defense' do
        base = create(:living_base, level: 5)
        expect(base.health).to eq(1.0)
        expect(base.current_defense).to be > 1
        expect{ base.receive_damage(0.5) }.to change(base, :health)
        expect(base.health).to be > 0.6
      end
    end
  end

  context 'when attacking' do
    before(:all) do
      @base = create(:base)
    end

    after(:all) do
      @base.destroy
    end

    it 'cannot attack bases' do
      base2 = create(:base)
      expect(@base.can_attack?(base2)).to eq(false)
    end

    it 'can attack troops' do
      troop = build(:troop)
      expect(@base.can_attack?(troop)).to eq(true)
    end

    it 'cannot attack towers' do
      tower = create(:tower)
      expect(@base.can_attack?(tower)).to eq(false)
    end

    it 'cannot attack out-of-range targets' do
      base = create(:base, location: 10)
      troop = create(:troop, location: 0)
      expect(base).to respond_to(:current_range)
      expect(base.current_range).to be < (base.location - troop.location).abs
      expect(base).to respond_to(:in_range)
      expect(base.in_range([troop])).to be_empty
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
