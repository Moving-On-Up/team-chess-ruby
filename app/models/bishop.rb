# frozen_string_literal: true

class Bishop < Piece
  def valid_move?(new_x_position, new_y_position, _id = nil, _color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)
    (x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance)

    if diagonal?(x_distance, y_distance)
      true
    elsif
      vertical?(new_y_position) || horizontal?(new_x_position) || is_obstructed?(x_distance, y_distance)
      false
    end
  end
end
