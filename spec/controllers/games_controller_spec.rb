require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user, id: 1)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#create action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user)
      sign_in user

      game = FactoryBot.create(:game, user: user, white_player_id: user, current_status: "inactive", current_user: user)

      expect(response).to have_http_status(:success)
      expect(game.pieces.count).to eq 32
      
    end
  end

  describe "games#show action" do
    it "should successfully show the page" do

      user = FactoryBot.create(:user)
      sign_in user

      game = FactoryBot.create(:game, user: user, white_player_id: user, current_status: "inactive", current_user: user)

      get :show, params: { id: game.id }

  describe "games#show action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user, id: 1)
      sign_in user

      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  #describe "games#create" do
  #  it "should require users to be logged in" do
  #    game = FactoryBot.create(:game)
  #    post :create
  #    expect(response).to redirect_to new_user_session_path
  #  end

  #  it "should allow signed in users to create a new game in the database" do
  #    user1 = FactoryBot.create(:user, id: 1)
  #    user2 = FactoryBot.create(:user, id: 7)
  #    sign_in user1      
  #    sign_in user2
  #    post :create, params:{game:{white_player_id:1,black_player_id:7}}
  #    game = Game.last
  #    piece = game.pieces.find_by(white:false)
  #    #expect(game.black_player_id).to eq 7
  #    expect(piece.player_id).to eq 7
  #    piece = game.pieces.find_by(white:true)
  #    expect(piece.player_id).to eq 1
  #  end
  #end

  #describe "games#join" do

  #  it "should redirect users who have not signed in to sign in" do
  #    game = FactoryBot.create(:game)
  #    patch :join, params:{id: game.id}
  #    expect(response).to redirect_to new_user_session_path
  #  end

  #  it "should allow signed in users to join unmatched games, piece user_id to be updated by the joining player id" do
  #    user1 = FactoryBot.create(:user, id:1)
  #    user2 = FactoryBot.create(:user, id:2)
  #    sign_in user1

  #    post :create, params:{game:{white_player_id: user1.id}}
  #    game = Game.last
  #    piece_white1 = game.pieces.find_by(white:true)
  #    expect(piece_white1.user_id).to eq user1.id
  #    sign_out user1
  #    sign_in user2
  #    patch :join, params:{id: game.id, game:{black_player_id: user2.id}}
  #    game.reload
  #    expect(game.black_player_id).to eq user2.id
  #    piece_white2 = game.pieces.find_by(white:true)
  #    expect(piece_white2.user_id).to eq user1.id
  #    piece_black = game.pieces.find_by(white:false)
  #    expect(piece_black.user_id).to eq user2.id
  #    expect(response).to redirect_to game_path(game)
  #  end
  #end

end
