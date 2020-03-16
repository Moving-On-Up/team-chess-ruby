class Knight < Piece

  def valid_move?(new_x_position, new_y_position, id = nil, white = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    puts "x_distance is " + x_distance.to_s
    puts "y_distance is " + y_distance.to_s

    (x_distance == 1 && y_distance == 2) || (x_distance == 2 && y_distance == 1)

   end
end