require 'rails_helper'

describe Tower do
  it 'should filter by living'

  context 'after creation' do
    it 'should be living' do
      tower = create(:tower)
      expect(tower).to be_living
    end

    it 'should not be dead' do
      tower = create(:tower)
      expect(tower).to_not be_dead
    end

    it 'should have less than 1 current attack' do
      tower = create(:tower)
      expect(tower.current_attack).to be < 1
    end

    it 'should have 0 current defense' do
      tower = create(:tower)
      expect(tower.current_defense).to eq(0)
    end

    it 'should have greater than 1 current range' do
      tower = create(:tower)
      expect(tower.current_range).to be > 1
    end

    it 'should have 0 current speed'
    it 'should have 0 base speed'
  end

  context 'when leveled up' do
    it 'should have increased current attack' do
      tower1 = create(:tower, level: 0)
      tower2 = create(:tower, level: 2)
      expect(tower2.current_attack).to be > tower1.current_attack
    end

    it 'should have increased current defense' do
      tower1 = create(:tower, level: 0)
      tower2 = create(:tower, level: 2)
      expect(tower2.current_defense).to be > tower1.current_defense
    end

    it 'should have increased current range' do
      tower1 = create(:tower, level: 0)
      tower2 = create(:tower, level: 2)
      expect(tower2.current_range).to be > tower1.current_range
    end
  end

  context 'when dead' do
    it 'should not be living' do
      tower = create(:dead_tower)
      expect(tower).to respond_to('living?')
      expect(tower).to_not be_living
    end

    it 'should be dead' do
      tower = create(:dead_tower)
      expect(tower).to respond_to('dead?')
      expect(tower).to be_dead
    end

    it 'should not attack' do
      tower = create(:dead_tower)
      troop = create(:troop)
      expect{ tower.attack(troop) }.to_not change(troop, :health)
    end

    context 'when receiving damage' do
      it 'should not lose health' do
        tower = create(:dead_tower)
        expect(tower).to respond_to(:receive_damage)
        expect{ tower.receive_damage(0.5) }.to_not change(tower, :health)
      end
    end
  end

  context 'when living' do
    context 'when attacking' do
      it 'can attack' do
        tower = create(:living_tower)
        expect(tower).to respond_to(:attack)
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
        tower = create(:living_tower)
        expect(tower).to respond_to(:receive_damage)
        expect{ tower.receive_damage(0.5) }.to change(tower, :health)
      end

      it 'can be killed' do
        tower = create(:living_tower)
        expect{ tower.receive_damage(1000.0) }.to change(tower, :health).to(0.0)
        expect(tower).to be_dead
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

  it 'cannot be created without a location' do
    tower = build(:tower, location: nil)
    expect{ tower.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it 'cannot be created without a position' do
    tower = build(:tower, position: nil)
    expect{ tower.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it 'cannot advance location' do
    tower = create(:tower)
    expect{ tower.advance_location }.to raise_error(Exceptions::ImmobilePieceError)
  end

  it 'cannot attack towers' do
    tower1 = create(:tower)
    tower2 = create(:tower)
    expect(tower1.can_attack?(tower2)).to eq(false)
  end

  it 'can attack troops' do
    tower = create(:tower)
    troop = create(:troop)
    expect(tower.can_attack?(troop)).to eq(true)
  end

  it 'cannot attack bases' do
    tower = create(:tower)
    base = create(:base)
    expect(tower.can_attack?(base)).to eq(false)
  end

  it 'cannot attack out-of-range targets' do
    tower = create(:tower, location: 10)
    troop = create(:troop, location: 50)
    expect(tower).to respond_to(:current_range)
    expect(tower.current_range).to be < (tower.location - troop.location).abs
    expect(tower).to respond_to(:in_range)
    expect(tower.in_range([troop])).to be_empty
  end

  it 'can attack in-range targets'
end
