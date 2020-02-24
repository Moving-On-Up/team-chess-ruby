class Queen < Piece

  def valid_move?(new_x_position, new_y_position, id = nil, color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    (x_distance >= 1 && y_distance == 0) || (y_distance >= 1 && x_distance == 0) || ((x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance))
  

   return true if self.diagonal?(x_distance, y_distance) || self.vertical?(new_y_position) || self.horizontal?(new_x_position)
   return false if self.is_obstructed?(x_distance, y_distance)
  end
end