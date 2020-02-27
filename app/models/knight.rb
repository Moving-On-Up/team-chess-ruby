class Knight < Piece
  def valid_move?(new_x_position, new_y_position, _id = nil, _color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    (x_distance == 1 && y_distance == 2) || (x_distance == 2 && y_distance == 1)

    tiles = [1, 2, 3, 4, 5, 6, 7]
    moves = []

    tiles.each do |_x|
      x_moves1 = x_distance + 1
      x_moved1 = x_distance - 1
      x_moves2 = x_distance + 2
      x_moved2 = x_distance - 2
      y_moves1 = y_distance + 1
      y_moved1 = y_distance - 1
      y_moves2 = y_distance + 2
      y_moved2 = y_distance - 2

      move1 = x_moves1 > 7 || y_moves2 > 7 ? nil : [x_moves1, y_moves2]
      move2 = x_moves1 > 7 || y_moved2 < 0 ? nil : [x_moves1, y_moved2]
      move3 = x_moved1 < 0 || y_moves2 > 7 ? nil : [x_moved1, y_moves2]
      move4 = x_moved1 < 0 || y_moved2 < 0 ? nil : [x_moved1, y_moved2]
      move5 = x_moves2 > 7 || y_moves1 > 7 ? nil : [x_moves2, y_moves1]
      move6 = x_moves2 > 7 || y_moved1 < 0 ? nil : [x_moves2, y_moved1]
      move7 = x_moved2 < 0 || y_moves1 > 7 ? nil : [x_moved2, y_moves1]
      move8 = x_moved2 < 0 || y_moved1 < 0 ? nil : [x_moved2, y_moved1]

      move1 = [x_moves1, y_moves2]
      move2 = [x_moves1, y_moved2]
      move3 = [x_moved1, y_moves2]
      move4 = [x_moved1, y_moved2]
      move5 = [x_moves2, y_moves1]
      move6 = [x_moved2, y_moved1]
      move7 = [x_moved2, y_moves1]
      move8 = [x_moved2, y_moved1]
      moves.push(move1, move2, move3, move4, move5, move6, move7, move8)
    end

    moves.delete_if { |move| move.include?(nil) }
    moves.delete_if { |moves| !moves.include?([new_x_position, new_y_position]) }

    moves == []
  end
end
