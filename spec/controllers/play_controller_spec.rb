require 'rails_helper'

describe PlayController do
  describe 'GET #index' do
    it 'show the debug screen' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:timelinegame)
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
        match = create(:match)
        get :advance_game, { match_id: match.id }
        expect(response).to have_http_status(:success)
        expect(response).to_not have_http_status(:error)
      end
    end
  end
end