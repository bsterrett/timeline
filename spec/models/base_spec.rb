require 'rails_helper'

describe Base do
  it 'should filter by living'

  context 'after creation' do
    it 'should be living' do
      base = create(:base)
      expect(base).to be_living
    end

    it 'should not be dead' do
      base = create(:base)
      expect(base).to_not be_dead
    end

    it 'should have less than 1 current attack' do
      base = create(:base)
      expect(base.current_attack).to be < 1
    end

    it 'should have 0 current defense' do
      base = create(:base)
      expect(base.current_defense).to eq(0)
    end

    it 'should have greater than 1 current range' do
      base = create(:base)
      expect(base.current_range).to be > 1
    end

    it 'should have 0 current speed'
    it 'should have 0 base speed'
  end

  context 'when leveled up' do
    it 'should have increased current attack' do
      base1 = create(:base, level: 0)
      base2 = create(:base, level: 2)
      expect(base2.current_attack).to be > base1.current_attack
    end

    it 'should have increased current defense' do
      base1 = create(:base, level: 0)
      base2 = create(:base, level: 2)
      expect(base2.current_defense).to be > base1.current_defense
    end

    it 'should have increased current range' do
      base1 = create(:base, level: 0)
      base2 = create(:base, level: 2)
      expect(base2.current_range).to be > base1.current_range
    end
  end

  context 'when dead' do
    it 'should not be living' do
      base = create(:dead_base)
      expect(base).to respond_to('living?')
      expect(base).to_not be_living
    end

    it 'should be dead' do
      base = create(:dead_base)
      expect(base).to respond_to('dead?')
      expect(base).to be_dead
    end

    it 'should not attack' do
      base = create(:dead_base)
      troop = create(:troop)
      expect{ base.attack(troop) }.to_not change(troop, :health)
    end

    context 'when receiving damage' do
      it 'should not lose health' do
        base = create(:dead_base)
        expect(base).to respond_to(:receive_damage)
        expect{ base.receive_damage(0.5) }.to_not change(base, :health)
      end
    end
  end

  context 'when living' do
    context 'when attacking' do
      it 'can attack' do
        base = create(:living_base)
        expect(base).to respond_to(:attack)
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
        base = create(:living_base)
        expect(base).to respond_to(:receive_damage)
        expect{ base.receive_damage(0.5) }.to change(base, :health)
      end

      it 'can be killed' do
        base = create(:living_base)
        expect{ base.receive_damage(1000.0) }.to change(base, :health).to(0.0)
        expect(base).to be_dead
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

  it 'cannot be created without a location' do
    base = build(:base, location: nil)
    expect{ base.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it 'cannot be created without a position' do
    base = build(:base, position: nil)
    expect{ base.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it 'cannot advance location' do
    base = create(:base)
    expect{ base.advance_location }.to raise_error(Exceptions::ImmobilePieceError)
  end

  it 'cannot attack bases' do
    base1 = create(:base)
    base2 = create(:base)
    expect(base1.can_attack?(base2)).to eq(false)
  end

  it 'cannot attack towers' do
    base = create(:base)
    tower = create(:tower)
    expect(base.can_attack?(tower)).to eq(false)
  end

  it 'can attack troops' do
    base = create(:base)
    troop = create(:troop)
    expect(base.can_attack?(troop)).to eq(true)
  end

  it 'cannot attack out-of-range targets' do
    base = create(:base, location: 0)
    troop = create(:troop, location: 50)
    expect(base).to respond_to(:current_range)
    expect(base.current_range).to be < (base.location - troop.location).abs
    expect(base).to respond_to(:in_range)
    expect(base.in_range([troop])).to be_empty
  end

  it 'can attack in-range targets'
end
