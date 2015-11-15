require 'rails_helper'

describe Troop do
  context 'after creation' do
    it 'should be living' do
      troop = create(:troop)
      expect(troop).to be_living
    end
  end

  context 'when dead' do
    it 'should be dead' do
      troop = create(:dead_troop)
      expect(troop).to respond_to('dead?')
      expect(troop).to be_dead
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
        troop = create(:dead_troop)
        expect(troop).to respond_to(:receive_damage)
        expect{ troop.receive_damage(0.5) }.to_not change(troop, :health)
      end
    end
  end

  context 'when living' do
    context 'when receiving damage' do
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
  end

  it 'cannot be created without a location' do
    troop = build(:troop, location: nil)
    expect{ troop.save }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it 'cannot attack troops' do
    troop1 = create(:troop)
    troop2 = create(:troop)
    expect(troop1.can_attack?(troop2)).to eq(false)
  end

  it 'cannot attack towers' do
    troop = create(:troop)
    tower = create(:tower)
    expect(troop.can_attack?(tower)).to eq(false)
  end

  it 'can attack bases' do
    troop = create(:troop)
    base = create(:base)
    expect(troop.can_attack?(base)).to eq(true)
  end

  it 'cannot attack out-of-range targets' do
    troop = create(:troop, location: 10)
    base = create(:base, location: 0)
    expect(troop).to respond_to(:current_range)
    expect(troop.current_range).to be < (troop.location - base.location).abs
    expect(troop).to respond_to(:in_range)
    expect(troop.in_range([base])).to be_empty
  end
end
