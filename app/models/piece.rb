class Piece < ApplicationRecord

  belongs_to :user, required: false
  belongs_to :game

  self.inheritance_column = :piece_type
    
  def self.types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  def contains_own_piece?(x_end, y_end)
    piece = game.pieces.where("x_position = ? AND y_position = ?", x_end, y_end).first
    piece.present? && piece.white == self.white
  end

  def opposition_piece?(x_end, y_end, id = nil, color = nil)
    piece = game.pieces.where("x_position = ? AND y_position = ?", x_end, y_end).first
    if id == nil
      if piece.blank?
        return false
      elsif piece.white != white
        return true
      elsif piece.white == white
        return false
      end
    elsif self.id == id && piece.blank? #empty square
      return false
    elsif self.id == id && piece.white != white #the piece is moving into square that has a opposite piece
      return true
    elsif self.id != id && self.white != color # ex: King moving to square above pawn, and when performing king.check?, pawn will recognize there is an opposition piece, making the vertical move false
      return true
    else
      return false
    end
  end

  #build_obstruction_array is identical to is_obstruct, except that we want the array, and not the boolean
  def build_obstruction_array(x_end, y_end)
    y_change = y_position - y_end
    x_change = x_position - x_end

    # Build array squares which piece must move through
    obstruction_array = []
    if x_change.abs == 0 # If it's moving vertically
      (1..(y_change.abs-1)).each do |i|
          obstruction_array << [x_position, y_position - (y_change/y_change.abs) * i]
      end
    elsif y_change.abs == 0 # If horizontally
      (1..(x_change.abs-1)).each do |i| # 7 times do (0..6).each do
          obstruction_array << [x_position - (x_change/x_change.abs) * i, y_position]
      end
    elsif y_change.abs == x_change.abs #if diagonally
      (1..(y_change.abs-1)).each do |i|
          obstruction_array << [x_position - (x_change/x_change.abs) * i, y_position - (y_change/y_change.abs) * i]
      end
    end
    obstruction_array
  end

  def is_obstructed?(new_x, new_y)
    if self.game.pieces.where(x_position: self.x_position, y_position: self.y_position).first.piece_type == "Knight"
      return false
    end

    new_x = new_x.to_i
    new_y = new_y.to_i
    
    current_piece = self
    
    x_distance = (current_piece.x_position.to_i - new_x).abs
    y_distance = (current_piece.y_position.to_i - new_y).abs

    if (up?(new_x, new_y) || down?(new_x, new_y)) && y_distance == 1
      return false
    end

    if (left?(new_x, new_y) || right?(new_x, new_y)) && x_distance == 1
      return false
    end

    if up?(new_x, new_y) 
      for i in current_piece.y_position+1..new_y-1 do 
        if game.pieces.find_by(x_position: new_x, y_position: i) != nil
          return true
        end
      end
    elsif down?(new_x, new_y)

      for i in new_y+1..current_piece.y_position-1 do 
        if game.pieces.find_by(x_position: new_x, y_position: i) != nil
          return true
        end
      end
    elsif left?(new_x, new_y)

      for i in new_x+1..current_piece.x_position-1 do 
        if game.pieces.find_by(x_position: i, y_position: new_y) != nil
          return true
        end
      end
    elsif right?(new_x, new_y)

      for i in current_piece.x_position+1..new_x-1 do 
        if game.pieces.find_by(x_position: i, y_position: new_y) != nil
          return true
        end
      end
    elsif diagonal?(x_distance, y_distance)
      if new_x > current_piece.x_position && new_y < current_piece.y_position
        for i in 1..x_distance-1 do
          if !game.pieces.where(x_position: current_piece.x_position+i, y_position: current_piece.y_position-i).blank?
            return true
          end
        end

      elsif new_x > current_piece.x_position && new_y > current_piece.y_position
        for i in 1..x_distance-1 do
          if !game.pieces.where(x_position: current_piece.x_position+i, y_position: current_piece.y_position+i).blank?
            return true
          end
        end

      elsif new_x < current_piece.x_position && new_y < current_piece.y_position
        for i in 1..x_distance-1 do
          if !game.pieces.where(x_position: current_piece.x_position-i, y_position: current_piece.y_position-i).blank?
            return true
          end
        end

      else
        for i in 1..x_distance-1 do
          if !game.pieces.where(x_position: current_piece.x_position-i, y_position: current_piece.y_position+i).blank?
            return true
          end
        end

      end
    else
      # If not a knight and not a N/S/E/W move, it's not valid so return true for now
      return true
    end

    return false

  end


  def color
    white? ? 'white' : 'black'
  end

  def white?
    white
  end

  def black?
    !white
  end

  def image
    image ||= "#{name}.png"
  end

  # determines horizontal distance travelled by piece
  def x_distance(new_x_position)
    (new_x_position.to_i - self.x_position).abs 
  end

  # determines vertical distance travelled by piece
  def y_distance(new_y_position)
    (new_y_position.to_i - self.y_position).abs  
  end

  # returns true if piece is moving from bottom to top
  def up?(new_x_position, new_y_position)
    (self.y_position - new_y_position.to_i) > 0 && (new_x_position == self.x_position)
  end

  # returns true if piece is moving from top to bottom
  def down?(new_x_position, new_y_position)
    (self.y_position - new_y_position.to_i) < 0 && (new_x_position == self.x_position)
  end

  # returns true if piece is moving from right to left
  def left?(new_x_position, new_y_position)
    (self.x_position - new_x_position.to_i) > 0 && (new_y_position == self.y_position)
  end

  # returns true if piece is moving from left to right
  def right?(new_x_position, new_y_position)
    (self.x_position - new_x_position.to_i) < 0 && (new_y_position == self.y_position)
  end

  def diagonal?(x_distance, y_distance)
    x_distance == y_distance
  end

  def capturable(capture_piece)
    (capture_piece.present? && capture_piece.color != color)
  end

  def find_capture_piece(x_end, y_end)
    if self.piece_type == "Pawn"
      if en_passant?(x_end, y_end)
        if self.white?
          game.pieces.find_by(x_position: x_end, y_position: y_end+1)
        else # black
          game.pieces.find_by(x_position: x_end, y_position: y_end-1)
        end
      end
    else
      game.pieces.where(x_position: x_end, y_position: y_end).first
    end
  end

  def move_to!(new_x,new_y)
    new_x = new_x.to_i
    new_y = new_y.to_i
    if !correct_turn?
      return false
    else
      if !verify_valid_move(new_x, new_y)
         return false
      else
        if (king_not_moved_to_check_or_king_not_kept_in_check?(new_x, new_y) == false) 
          if !game.pieces.where(x_position: new_x, y_position: new_y).blank? &&
            game.pieces.where(x_position: new_x, y_position: new_y).first.king_check == 1 &&
            game.pieces.where(white: !self.white?, king_check: 1).count == 1
          else
            return false
          end
        end

        dead_piece = game.pieces.find_by(x_position: new_x, y_position: new_y)
        if dead_piece != nil
          if opposition_piece?(new_x, new_y, id = dead_piece.id, white = dead_piece.white)
            move_to_capture_piece_and_capture(dead_piece, new_x, new_y)
            switch_turns
            self.update_attributes(move_number: move_number+1)
          else
            return false
          end
        else
          if (self.piece_type == "King" && (new_x - self.x_position).abs == 2 && self.legal_to_castle?(new_x, new_y) )
            self.castle(new_x, new_y)
            switch_turns
            return true
            # Don't update move number since castle already does that
          elsif (self.piece_type == "Pawn" && en_passant?(new_x,new_y))
            dead_piece = find_capture_piece(new_x, new_y)
            move_to_capture_piece_and_capture(dead_piece, new_x, new_y)
            switch_turns
            self.update_attributes(move_number: move_number+1)
            return true
          else
            move_to_empty_square(new_x, new_y)
            switch_turns
            self.update_attributes(move_number: move_number+1)
            return true
          end

          if self.piece_type == "Pawn"
            if self.move_number == 1 && en_passant_eligible?(new_x,new_y)
              self.update_attributes(en_passant_eligible: 1)
            elsif self.move_number != 1 || !en_passant_eligible?(new_x,new_y)
              self.update_attributes(en_passant_eligible: 0)
            end
          end
        end
      end
    end
  end

  def move_to_capture_piece_and_capture(dead_piece, x_end, y_end)
      self.x_position = x_end
      self.y_position = y_end
      self.status = 200
      self.save
      remove_piece(dead_piece)
  end
 
  def remove_piece(dead_piece)
    dead_piece.x_position = nil
    dead_piece.y_position = nil
    dead_piece.captured = true
    dead_piece.king_check = 0
    dead_piece.save
  end

  def move_to_empty_square(x_end, y_end)
    self.x_position = x_end
    self.y_position = y_end
    self.save
  end

  def update_winner
    self.game.current_status = "end"
    if white?
      self.game.winner_user_id = game.black_player_id
    else
      self.game.winner_user_id = game.white_player_id
    end
  end

  def update_loser
    self.game.current_status = "end"
    if white?
      self.game.loser_user_id = game.black_player_id
    else
      self.game.loser_user_id = game.white_player_id
    end
  end

  def name
    "#{self.piece_type}_#{self.white ? 'white' : 'black' }"
  end

  def verify_two_players
    if !(self.game.black_player_id && self.game.white_player_id)
      self.status = 422
    else
      self.status = 200
    end
    self.save
  end

  def switch_turns
    if self.game.white_player_id == self.game.turn_player_id
      self.game.turn_player_id = self.game.black_player_id
    elsif self.game.black_player_id == self.game.turn_player_id
      self.game.turn_player_id = self.game.white_player_id
    end
    self.game.save
  end

  def verify_valid_move(new_x, new_y) 
    if self.valid_move?(new_x, new_y, self.id, self.white) &&
      (self.is_obstructed?(new_x, new_y) == false) &&
      (self.contains_own_piece?(new_x, new_y) == false) ||
      (self.piece_type == "Pawn" && self.pawn_promotion?)
      return true
    else
      self.status = 422
      return false
    end
    self.save
  end

  def verify_player_turn
    if correct_turn? &&
      ((self.game.white_player_id == self.player_id && self.white?) ||
      (self.game.black_player_id == self.player_id && self.black?))
    else
      self.status = 422
    end
    self.save
  end

  def correct_turn?
    self.game.turn_player_id == self.player_id
  end

  def piece_params
    piece = self
    return params = {piece: "piece", x_position: "self.x_position", y_position: "self.y_position", captured: "self.captured", white: "self.white", id: "self.id", piece_type: "self.piece_type"}
  end

  def king_not_moved_to_check_or_king_not_kept_in_check?(new_x, new_y)
    #function checks if player is not moving king into a check position
    #and also checking that if king is in check, player must move king out of check,
    #this function restricts any other random move if king is in check.

    # Both scenarios can be checked by moving to new coordinates then checking for check
    original_x = self.x_position
    original_y = self.y_position
    self.x_position = new_x
    self.y_position = new_y
    self.save
    current_king = self.game.pieces.where(white: self.white, piece_type: "King").first
    if current_king.check?
      self.x_position = original_x
      self.y_position = original_y
      self.save
      return false
    else
      self.x_position = original_x
      self.y_position = original_y
      self.save
      return true
    end

  end

  def update_moves(new_x, new_y)
    self.x_position = new_x
    self.y_position = new_y
    self.save
  end

end
