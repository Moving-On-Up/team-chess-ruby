# frozen_string_literal: true

class Rook < Piece
  def valid_move?(new_x_position, new_y_position, _id = nil, _color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)
    (x_distance >= 1 && y_distance == 0) || (y_distance >= 1 && x_distance == 0)

    tiles = [1, 2, 3, 4, 5, 6, 7]
    moves = []

    tiles.each do |x|
      x_move1 = x_distance + x > 7 ? nil : x_distance + x
      x_move2 = x_distance - x < 0 ? nil : x_distance - x
      y_move1 = y_distance + x > 7 ? nil : y_distance + x
      y_move2 = y_distance - x < 0 ? nil : y_distance - x

      move1 = [x_move1, y_distance]
      move2 = [x_move2, y_distance]
      move3 = [x_distance, y_move1]
      move4 = [x_distance, y_move2]
      moves.push(move1, move2, move3, move4)
    end

    moves.delete_if { |moves| moves.include?(nil) }
    moves.delete_if { |moves| !moves.include?([new_x_position, new_y_position]) }

    moves == []
  end
end
