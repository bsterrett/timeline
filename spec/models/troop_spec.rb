require 'rails_helper'

describe Troop do
  it 'should filter by living'

  context 'after creation' do
    before(:all) do
      @troop = create(:troop)
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
      expect(@troop.current_defense).to eq(0)
    end

    it 'should have 1 current range' do
      expect(@troop.current_range).to eq(1)
    end

    it 'should have 0 current speed'
    it 'should have 0 base speed'

    after(:all) do
      @troop.destroy
    end
  end

  context 'when leveled up' do
    before(:all) do
      @troop1 = create(:troop, level: 0)
      @troop2 = create(:troop, level: 2)
    end

    it 'should have increased current attack' do

      expect(@troop2.current_attack).to be > @troop1.current_attack
    end

    it 'should have increased current defense' do
      expect(@troop2.current_defense).to be > @troop1.current_defense
    end

    it 'should have not increased current range' do
      expect(@troop2.current_range).to be == @troop1.current_range
    end

    after(:all) do
      @troop1.destroy
      @troop2.destroy
    end
  end

  context 'when dead' do
    before(:all) do
      @troop = create(:dead_troop)
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

    after(:all) do
      @troop.destroy
    end
  end

  context 'when living' do
    before(:all) do
      @troop = create(:living_troop)
    end

    context 'when attacking' do
      it 'can attack' do
        expect(@troop).to respond_to(:attack)
      end

      context 'receives actual damage dealt' do
        it 'when target has zero defense'
        it 'when target has nonzero defense'
        it 'when the target is killed'
        it 'when more damage is applied than the targets health'
      end
    end

    context 'when receiving damage' do
      context 'should return actual damage received' do
        it 'when target has zero defense'
        it 'when target has nonzero defense'
        it 'when the target is killed'
        it 'when more damage is applied than the targets health'
      end

      it 'can receive damage' do
        troop = create(:living_troop)
        expect(troop).to respond_to(:receive_damage)
        expect{ troop.receive_damage(0.5) }.to change(troop, :health)
      end

      it 'can be killed' do
        troop = create(:living_troop)
        expect{ troop.receive_damage(1000.0) }.to change(troop, :health).to(0.0)
        expect(troop).to be_dead
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
          expect{ troop.advance_location }.to change(troop, :location).by(-1)
        end
      end
    end

    after(:all) do
      @troop.destroy
    end
  end

  context 'when attacking' do
    before(:all) do
      @troop = create(:troop)
    end

    it 'cannot attack troops' do
      troop2 = create(:troop)
      expect(@troop.can_attack?(troop2)).to eq(false)
    end

    it 'cannot attack towers' do
      tower = create(:tower)
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

    after(:all) do
      @troop.destroy
    end
  end

  it 'cannot be created without a location' do
    troop = build(:troop, location: nil)
    expect{ troop.save }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
