require 'rails_helper'

describe PlayController do
  describe 'GET #index' do
    it 'show the debug screen' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:timelinegame)
    end
  end

  describe 'GET #new_match' do
    context 'with valid parameters' do
      it 'return debug information for a new match' do
        users = FactoryGirl.create_list(:user, 2)
        map = FactoryGirl.create(:map)
        get :new_match, { user_ids: users.collect(&:id), map_id: map.id }
        expect(response).to render_template(:timelinegame)
      end

      it 'have success status' do
        users = FactoryGirl.create_list(:user, 2)
        map = FactoryGirl.create(:map)
        get :new_match, { user_ids: users.collect(&:id), map_id: map.id }
        expect(response).to have_http_status(:success)
      end

      it 'create players for every user' do
        users = FactoryGirl.create_list(:user, 2)
        map = FactoryGirl.create(:map)
        get :new_match, { user_ids: users.collect(&:id), map_id: map.id }
        expect(Player.count).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'should not create a new match' do
        users = FactoryGirl.create_list(:user, 2)
        get :new_match, { user_ids: users.collect(&:id), map_id: nil }
        expect(Match.count).to eq(0)
      end

      it 'should return an error' do
        users = FactoryGirl.create_list(:user, 2)
        get :new_match, { user_ids: users.collect(&:id), map_id: nil }
        expect(response).to have_http_status(:error)
      end
    end
  end

  describe 'GET #advance_game' do
    context 'with invalid attributes' do
      it 'does not advance the game' do
        # get :advance_game, {}
        # game.frame something
      end

      it 'returns an error message' do
        get :advance_game, {}
        expect(response).to have_http_status(:error)
      end
    end

    context 'with valid attributes' do
      it 'advances the game' do
        # get :advance_game, {}
        # game.frame something
      end

      it 'return debug information for current match' do
        get :advance_game, {}
        expect(response).to render_template(:timelinegame)
      end

      it 'have success status' do
        match = FactorGirl.create(:match)
        get :advance_game, { match_id: match.id }
        expect(response).to have_http_status(:success)
      end
    end
  end
end