# frozen_string_literal: true

class Queen < Piece
  def valid_move?(new_x_position, new_y_position, _id = nil, _color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    (x_distance >= 1 && y_distance == 0) || (y_distance >= 1 && x_distance == 0) || ((x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance))

    if diagonal?(x_distance, y_distance) || vertical?(new_y_position) || horizontal?(new_x_position)
      true
    elsif is_obstructed?(x_distance, y_distance) || (x_distance + 1 == new_x_position && y_distance - 2 == y) ||
          (x_distance + 2 == new_x_position && y_distance - 1 == new_y_position) ||
          (x_distance + 2 == new_x_position && y_distance + 1 == new_y_position) ||
          (x_distance + 1 == new_x_position && y_distance + 2 == new_y_position) ||
          (x_distance - 2 == new_x_position && y_distance - 1 == new_y_position) ||
          (x_distance - 1 == new_x_position && y_distance - 2 == new_y_position) ||
          (x_distance - 1 == new_x_position && y_distance + 2 == new_y_position) ||
          (x_distance - 2 == new_x_position && y_distance + 1 == new_y_position)
      false

    end
  end
end
