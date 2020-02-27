# frozen_string_literal: true

class King < Piece
  def valid_move?(new_x_position, new_y_position, _id = nil, _color = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    (x_distance == 1 && y_distance == 0) ||
      (y_distance == 1 && x_distance == 0) ||
      (y_distance == 1 && y_distance == x_distance) ||
      legal_to_castle?(new_x_position, new_y_position)
  end

  def check?(x_position, y_position, id = nil, color = nil)
    game.pieces.each do |f|
      next unless f.player_id != player_id && !f.x_position.nil?

      if f.valid_move?(x_position, y_position, id, color) == true && f.is_obstructed?(x_position, y_position) == false
        return f
        break
      end
    end
    false
  end

  def find_threat_and_determine_checkmate
    threat = check?(x_position, y_position)
    return true if check_mate?(threat)

    false
  end

  def check_mate?(threat)
    obstruction_array = threat.build_obstruction_array(x_position, y_position)
    # check if king can capture the threat
    if valid_move?(threat.x_position, threat.y_position) == true && check?(threat.x_position, threat.y_position).blank? ||
       # check if any other piece can move to block the king, or capture the threat
       can_block_king?(threat, obstruction_array) == true ||
       # check if king has many moves left
       any_moves_left?(threat, obstruction_array) == true
      false
    else
      true
    end
  end

  def stalemate?
    return true unless any_moves_left?

    false
  end

  def legal_to_castle?(new_x_position, new_y_position)
    return false unless move_number == 0
    unless x_distance(new_x_position) == 2 && y_distance(new_y_position) == 0
      return false
    end

    if new_x_position > x_position
      @rook_for_castling = game.pieces.where(piece_type: 'Rook', player_id: player_id, x_position: 8).first
    else
      @rook_for_castling = game.pieces.where(piece_type: 'Rook', player_id: player_id, x_position: 1).first
    end
    return false if @rook_for_castling.nil?

    unless @rook_for_castling.nil?
      return false unless @rook_for_castling.move_number == 0
      if is_obstructed?(@rook_for_castling.x_position, @rook_for_castling.y_position)
        return false
      end
    end
    true
  end

  def castle(new_x_position, new_y_position)
    return false unless legal_to_castle?(new_x_position, new_y_position)

    update_attributes(x_position: new_x_position, y_position: new_y_position, move_number: move_number + 1)
    if new_x_position == 3
      @rook_for_castling.update_attributes(x_position: 4, move_number: 1)
    else new_x_position == 7
         @rook_for_castling.update_attributes(x_position: 6, move_number: 1)
    end
  end

  private

  def any_moves_left?(threat = nil, obstruction_array = nil)
    possible_positions = []
    king_surrounding = []
    (1..8).each do |num1|
      (1..8).each do |num2|
        if valid_move?(num1, num2) == true && contains_own_piece?(num1, num2) == false && check?(num1, num2).blank?
          possible_positions << [num1, num2]
        end
        if valid_move?(num1, num2) == true && contains_own_piece?(num1, num2)
          king_surrounding << [num1, num2]
        end
      end
    end
    if threat.present?
      return true if (possible_positions - obstruction_array).count >= 1
    elsif move_number == 0 && king_surrounding.count == 5
      true
    elsif possible_positions.any?
      true
    else
      false
    end
  end

  def can_block_king?(threat, obstruction_array)
    game.pieces.each do |f|
      if f.player_id == player_id && !f.x_position.nil? && f != self
        if f.valid_move?(threat.x_position, threat.y_position) == true &&
           f.contains_own_piece?(threat.x_position, threat.y_position) == false &&
           f.is_obstructed?(threat.x_position, threat.y_position) == false
          return true
          break
        elsif !obstruction_array.empty?
          obstruction_array.each do |coord|
            return true if f.valid_move?(coord[0], coord[1]) == true &&
                           f.contains_own_piece?(coord[0], coord[1]) == false &&
                           f.is_obstructed?(coord[0], coord[1]) == false

            break
          end
        end
      end
    end
    false
  end
end
