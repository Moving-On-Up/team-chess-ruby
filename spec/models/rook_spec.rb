require 'rails_helper'

RSpec.describe Rook, type: :model do
  
  describe "#valid move?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }


    it "should return false to move one square forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end 

    it "should return false to move two squares forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end 
    
    it "should return false to move three squares forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move four squares forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move five squares forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move six squares forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move seven squares forward" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move one square back" do
      rook = FactoryBot.create(:rook, x_position: 1, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end 

    it "should return false to move two squares back" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end 
    
    it "should return false to move three squares back" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move four squares back" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move five squares back" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move six squares back" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move seven squares back" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(5, 6)).to eq(false)
    end


    it "should return false to move one square to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move two squares to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move three squares to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move four squares to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move five squares to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move six squares to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move seven squares to the left" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move one square to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move two squares to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move three squares to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move four squares to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move five squares to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move six squares to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 

    it "should return false to move seven squares to the right" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end 


    it "should return false to move to a non-same-color square" do
       = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 3)).to eq(false)
    end     
  end 

end