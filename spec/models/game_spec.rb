require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { FactoryBot.create(:game) }
 
  describe "#contains_piece?" do
    it "should return true if the end coordinates contains a piece" do
    expect(game.contains_piece?(2, 7)).to eq true
    end
  end

  describe "#is_in_check" do
    it 'should determine that the game is in check' do
    
    end
  end

  describe "#is_not_in_check" do
    it 'should determine that the game is not in check' do
  
    end
  end

  describe "#stalemate" do
    it 'should detect stalemate' do
    # White is in stalemate (returns true) and Black is not (returns false)
      
    end
  end

  describe "#checkmate" do
    it 'should detect checkmate' do
    
    end
  end

  describe "#not_in_checkmate" do
    it 'should detect state is not checkmate' do
      expect(game.checkmate).to eq false
    end
  end
end
