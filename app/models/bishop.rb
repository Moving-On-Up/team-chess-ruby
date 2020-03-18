class Bishop < Piece
  def valid_move?(new_x_position, new_y_position, id = nil, white = nil)
    x_dist = x_distance(new_x_position)
    y_dist = y_distance(new_y_position)

    def is_obstructed?(new_x_position, new_y_position)
      super
    end

    if (x_dist >= 1 && y_dist >= 1) && diagonal?(x_dist, y_dist)
      return true
    elsif up?(y_dist) || down?(y_dist)
      return false
    else 
      return false
    end
  end

 
  
end
