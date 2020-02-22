class Bishop < Piece
  
  def valid_move?(new_x_position, new_y_position, id = nil, color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    (x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance)
  end

  def check_move?()
    games.pieces.each do |b|
      if b.diagonal?(x_distance, y_distance) && b.is_obstructed?
        move_to! #new location
      else
        false #alert invalid move!
      end
    end
  end


end
