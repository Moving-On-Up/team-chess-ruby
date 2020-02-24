class Bishop < Piece
  
  def valid_move?(new_x_position, new_y_position, id = nil, color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    if self.diagonal?(x_distance, y_distance)  
      move_to(new_x_position, new_y_position)
    elsif self.is_obstructed?(x_distance, y_distance)
     return false
    end

    (x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance)
  end


end
