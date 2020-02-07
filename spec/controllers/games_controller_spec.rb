require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#create action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user)
      sign_in user

      #current_user.games.create(game_params.merge(white_player_id: current_user.id)
      #      .merge(current_status: "inactive").merge(current_user: current_user.id))

      post :create, params: { white_player_id: user, current_status: "inactive", current_user: user }

      expect(response).to redirect_to root_path
      #expect(gram.pieces.length).to eq 1
      expect(game.pieces.count).to eq 32
      
    end
  end

  describe "games#show action" do
    it "should successfully show the page" do

      user = FactoryBot.create(:user)
      sign_in user

      # current_user.games.create(game_params.merge(white_player_id: current_user.id)
      #       .merge(current_status: "inactive").merge(current_user: current_user.id))

      post :create, params: { white_player_id: user, current_status: "inactive", current_user: user }

      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

end
