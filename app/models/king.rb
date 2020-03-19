class King < Piece

  def valid_move?(new_x_position, new_y_position, id = nil, white = nil)
    x_distance = x_distance(new_x_position)
    y_distance = y_distance(new_y_position)

    (x_distance == 1 && y_distance == 0) ||
    (y_distance == 1 && x_distance == 0) ||
    (y_distance == 1 && y_distance == x_distance) ||
    legal_to_castle?(new_x_position, new_y_position)
  end

  def check?(x_position, y_position, id = nil, white = nil)
    game.pieces.each do | f |
      if f.player_id != self.player_id && f.x_position != nil
        if f.valid_move?(x_position, y_position, id, white) == true && 
           f.is_obstructed?(x_position, y_position) == false 
            f.king_check = 1
            f.save
            return f ##true
            break
        end
      end
    end
    return false   
  end


  # def in_check?
  #   king = self
  #   x_king = king.x_position
  #   y_king = king.y_position
 
  #   if !user
  #     self.game.pieces.each do |piece|
  #       if piece.valid_move?(x_king, y_king)
  #         return true
  #       end
  #     end
  #   end 
  #   return false
  # end

  def find_threat_and_determine_checkmate     ### DOES NOT WORK CORRECTLY
    #binding.pry
    threat = check?(x_position, y_position)
    if checkmate?(threat)
      return true
    end
    return false
  end

  # def check_mate?(threat)
  #   obstruction_array = threat.build_obstruction_array(x_position, y_position)
  #   # check if king can capture the threat
  #   if valid_move?(threat.x_position, threat.y_position) == true && check?(threat.x_position, threat.y_position).blank? ||
  #   # check if any other piece can move to block the king, or capture the threat
  #     can_block_king?(threat, obstruction_array) == true ||
  #   # check if king has many moves left
  #     any_moves_left?(threat, obstruction_array) == true
  #     #binding.pry
  #     return false
  #   else
  #     #binding.pry
  #     return true
  #   end
  # end

  def checkmate?(threat)
    return false unless check?(x_position, y_position)
    return false if valid_move?(x_position, y_position) 
    return false if stalemate?
    true
  end


  def stalemate?
    return true if !check?(x_position, y_position)
    return true if no_legal_next_move?
    return false
  end

  def legal_to_castle?(new_x_position, new_y_position)
    return false unless self.move_number == 0
    return false unless x_distance(new_x_position) == 2 && y_distance(new_y_position) == 0
    if new_x_position > x_position
      @rook_for_castling = self.game.pieces.where(piece_type: "Rook", player_id: self.player_id, x_position: 8).first
    else
      @rook_for_castling = self.game.pieces.where(piece_type: "Rook", player_id: self.player_id, x_position: 1).first
    end
    return false if @rook_for_castling.nil?
    if !@rook_for_castling.nil?
      return false unless @rook_for_castling.move_number == 0
      return false if is_obstructed?(@rook_for_castling.x_position, @rook_for_castling.y_position)
    end
    return true
  end

  def castle(new_x_position, new_y_position)
    return false unless legal_to_castle?(new_x_position, new_y_position)
    self.update_attributes(x_position: new_x_position, y_position: new_y_position, move_number: self.move_number + 1)
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
        if valid_move?(num1,num2) == true && contains_own_piece?(num1,num2) == false && check?(num1, num2).blank?
          possible_positions << [num1, num2]
        end
        if valid_move?(num1,num2) == true && contains_own_piece?(num1,num2)
          king_surrounding << [num1, num2]
        end
      end
    end
    if threat.present?
      return true if (possible_positions - obstruction_array).count >= 1
    elsif move_number == 0 && king_surrounding.count == 5
      return true
    elsif possible_positions.any?
      return true
    else
      return false
    end
  end

  def can_block_king?(threat,obstruction_array)
    game.pieces.each do |f|
      if f.player_id == self.player_id && f.x_position != nil && f != self
        if (f.valid_move?(threat.x_position, threat.y_position) == true &&
        f.contains_own_piece?(threat.x_position, threat.y_position) == false &&
        f.is_obstructed?(threat.x_position, threat.y_position) == false)
          return true
          break
        elsif !obstruction_array.empty?
          obstruction_array.each do |coord|
            return true if (f.valid_move?(coord[0],coord[1]) == true &&
            f.contains_own_piece?(coord[0],coord[1]) == false &&
            f.is_obstructed?(coord[0],coord[1]) == false)
            break
          end
        end
      end
    end
    return false
  end
  

  def no_legal_next_move?
    myPieces = game.pieces.where(piece_type: "King")
    myPieces.each do |piece|
      (1..8).each do |x|
        (1..8).each do |y|
          if piece.valid_move?(x_position, y_position)
            original_x = piece.x_position
            original_y = piece.y_position
            captured_piece = pieces.find_by(x_position: x, y_position: y)
            begin
              captured_piece.update(x_position: -1, y_position: -1) if captured_piece
              piece.update(x_position: x, y_position: y)
              reload
              check_state = check?(x_position, y_position)
            ensure
              piece.update(x_position: original_x, y_position: original_y)
              captured_piece.update(x_position: x, y_position: y) if captured_piece
              reload
            end
            if check_state.nil?
              return false
            end
          end
        end
      end
    end
    true
  end

end