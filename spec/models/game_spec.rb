require 'rails_helper'

RSpec.describe Game, type: :model do

 
  describe "#contains_piece?" do
    it "should return true if the end coordinates contains a piece" do
    
    
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



  describe "#black_turn?" do
    it 'should determine that player black is up' do
     
    end
  end

  describe "#white_turn?" do
    it 'should determine that player white is up' do
    
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
      
    end
  end
end
