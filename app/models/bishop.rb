class Bishop < Piece
  
  def valid_move?(new_x_position, new_y_position, id = nil, white = nil)
    x_dist = x_distance(new_x_position)
    y_dist = y_distance(new_y_position)

    if (x_dist >= 1 && y_dist >= 1) && diagonal?(x_dist, y_dist)
      return true
    else
      return false
    end
  end

end
