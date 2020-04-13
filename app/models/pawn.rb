class Pawn < Piece

  def valid_move?(new_x_position, new_y_position, id = nil, white = nil)

    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    new_x_position = new_x_position.to_i
    new_y_position = new_y_position.to_i

# ----- lines 9-12 Diagonal capture -----
# ----- lines 13-20 Vertical opening and subsequent moves valid only if there is no opposition piece/no piece at destination coordinate-------
# ----- Same color piece at destination coordinate is checked in the verify_valid_move in the piece model -----
    if en_passant?(new_x_position, new_y_position)
      return true
    elsif (x_distance == y_distance) && !white? && opposition_piece?(new_x_position, new_y_position, id, color)
      new_y_position == y_position + 1
    elsif (x_distance == y_distance) && white? && opposition_piece?(new_x_position, new_y_position, id, color)
      new_y_position == y_position - 1
    elsif y_position == 2 && black? && !opposition_piece?(new_x_position, new_y_position, id, color)
      x_distance == 0 && (new_y_position == 3 || new_y_position == 4)
    elsif y_position == 7 && white? && !opposition_piece?(new_x_position, new_y_position, id, color)
      x_distance == 0 && (new_y_position == 6 || new_y_position == 5)
    elsif !white? && !opposition_piece?(new_x_position, new_y_position, id, color)
      (x_distance == 0) && (new_y_position == (y_position + 1))
    elsif white? && !opposition_piece?(new_x_position, new_y_position, id, color)
      (x_distance == 0) && (new_y_position == (y_position - 1))
    else
      false
    end
  end

  def en_passant_eligible?(new_x_position, new_y_position)

    if self.white? && new_y_position != 5
      return false
    elsif self.black? && new_y_position != 4
      return false
    end

    if new_x_position > 1
      left_pawn = game.pieces.where(y_position: y_position, x_position: new_x_position-1, piece_type: "Pawn", white: !self.white).first
    end
    
    if new_x_position < 8
      right_pawn = game.pieces.where(y_position: y_position, x_position: new_x_position+1, piece_type: "Pawn", white: !self.white).first
    end

    if left_pawn.nil? && right_pawn.nil?
      return false
    else
      return true
    end
  end

  def en_passant?(new_x_position, new_y_position)
    return false unless ((new_y_position == y_position + 1 && !white?) || (new_y_position == y_position - 1 && white?)) && ((new_x_position == x_position + 1) || (new_x_position == x_position - 1)) && ((new_y_position == 3 && white?) || (new_y_position == 6 && !white?))
    other_piece = game.pieces.where(y_position: y_position, x_position: new_x_position, piece_type: "Pawn").first
    return false if other_piece.nil? || other_piece.move_number != 1 || other_piece.en_passant_eligible == 0
    return true
  end

  def pawn_promotion?
    pawn = game.pieces.where(:piece_type =>"Pawn").where(:player_id => game.turn_player_id)[0]
    (y_position == 8 && !white?) || (y_position == 1 && white?) #black pawn white baseline or white pawn black baseline
  end
  
end