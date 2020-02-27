# frozen_string_literal: true

class Move < ApplicationRecord
  belongs_to :game

  def notation(piece_type, x_position, y_position)
    x_mapping = { 1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd', 5 => 'e', 6 => 'f', 7 => 'g', 8 => 'h' }
    y_mapping = { 1 => '8', 2 => '7', 3 => '6', 4 => '5', 5 => '4', 6 => '3', 7 => '2', 8 => '1' }
    piece_mapping = { 'King' => 'K', 'Queen' => 'Q', 'Bishop' => 'B', 'Knight' => 'N', 'Rook' => 'R', 'Pawn' => ' ' }
    (piece_mapping[piece_type]).to_s + (x_mapping[x_position]).to_s + (y_mapping[y_position]).to_s
  end
end
