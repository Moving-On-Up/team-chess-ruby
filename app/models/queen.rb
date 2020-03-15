class Queen < Piece
 
  def valid_move?(new_x_position, new_y_position, id = nil, white = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    def is_obstructed?(new_x_position, new_y_position)
        super
    end
    (x_distance >= 1 && y_distance == 0) || (y_distance >= 1 && x_distance == 0) || ((x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance))

  end
  
end