require 'rails_helper'

describe MatchController do
  describe 'GET #show' do
    context 'with valid parameters' do
      it 'should return debug information for match' do
        match = create(:match)
        get :show, { id: match.id }
        expect(response).to render_template(:timelinegame)
      end

      it 'should have success status' do
        match = create(:match)
        get :show, { id: match.id }
        expect(response).to have_http_status(:success)
        expect(response).to_not have_http_status(:error)
      end

      it 'should not create a new match' do
        match = create(:match)
        expect{ get :show, { id: match.id } }.to_not change{ Match.count }
      end
    end

    context 'with invalid parameters' do
      it 'should have error status' do
        get :show, { id: nil }
        expect(response).to have_http_status(:error)
        expect(response).to_not have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'return debug information for a new match' do
        users = create_list(:user, 2)
        map = create(:map)
        post :create, { user_ids: users.collect(&:id), map_id: map.id }
        expect(response).to render_template(:timelinegame)
      end

      it 'have success status' do
        users = create_list(:user, 2)
        map = create(:map)
        post :create, { user_ids: users.collect(&:id), map_id: map.id }
        expect(response).to have_http_status(:success)
        expect(response).to_not have_http_status(:error)
      end

      it 'create players for every user' do
        users = create_list(:user, 2)
        map = create(:map)
        expect{ post :create, { user_ids: users.collect(&:id), map_id: map.id } }.to change{ Player.count }.by(2)
      end

      it 'creates one new match' do
        users = create_list(:user, 2)
        map = create(:map)
        expect{ post :create, { user_ids: users.collect(&:id), map_id: map.id } }.to change{ Match.count }.by(1)
      end

      it 'creates one new game' do
        users = create_list(:user, 2)
        map = create(:map)
        expect{ post :create, { user_ids: users.collect(&:id), map_id: map.id } }.to change{ Game.count }.by(1)
      end
    end

    context 'with invalid parameters' do
      it 'should not create a new match' do
        users = create_list(:user, 2)
        expect{ post :create, { user_ids: users.collect(&:id), map_id: nil } }.to_not change{ Match.count }
      end

      it 'should not create a new game' do
        users = create_list(:user, 2)
        expect{ post :create, { user_ids: users.collect(&:id), map_id: nil } }.to_not change{ Game.count }
      end

      it 'should not create new players' do
        users = create_list(:user, 2)
        expect{ post :create, { user_ids: users.collect(&:id), map_id: nil } }.to_not change{ Player.count }
      end

      it 'should return an error' do
        users = create_list(:user, 2)
        post :create, { user_ids: users.collect(&:id), map_id: nil }
        expect(response).to have_http_status(:error)
        expect(response).to_not have_http_status(:success)
      end
    end
  end
end