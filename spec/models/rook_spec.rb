require 'rails_helper'

RSpec.describe Rook, type: :model do
  it 'should check if vertical moves are valid' do
    @rook = FactoryBot.create(:rook, x_position: '0', y_position: '0')
    expect(@rook.valid_move?(0,1)).to eq true
  end

  it 'should check if horizontal moves are valid' do
    @rook = FactoryBot.create(:rook, x_position: '4', y_position: '4')
    expect(@rook.valid_move?(4,5)).to eq true
  end

  it 'should check if rook moving off board is invalid' do
    @rook = FactoryBot.create(:rook, x_position: '0', y_position: '0')
    expect(@rook.valid_move?(0,10)).to eq false
  end

end 