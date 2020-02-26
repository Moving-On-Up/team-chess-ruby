class Queen < Piece

  def valid_move?(new_x_position, new_y_position, id = nil, color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    if self.diagonal?(x_distance, y_distance) || self.vertical?(new_y_position) || self.horizontal?(new_x_position)
      return true
    elsif self.is_obstructed?(x_distance, y_distance) || (x_distance + 1 == new_x_position && y_distance - 2 == y) ||
      (x_distance + 2 == new_x_position && y_distance - 1 == new_y_position) ||
      (x_distance + 2 == new_x_position && y_distance + 1 == new_y_position) || 
      (x_distance + 1 == new_x_position && y_distance + 2 == new_y_position) ||
      (x_distance - 2 == new_x_position && y_distance - 1 == new_y_position) ||
      (x_distance - 1 == new_x_position && y_distance - 2 == new_y_position) || 
      (x_distance - 1 == new_x_position && y_distance + 2 == new_y_position) || 
      (x_distance - 2 == new_x_position && y_distance + 1 == new_y_position)
    return false
   
    end

  end
end