class Piece < ApplicationRecord
  #after_initialize :find_piece, :verify_two_players, :verify_player_turn, :verify_valid_move

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

    # if self.game.pieces.where(x_position: self.x_position, y_position: self.y_position).first.piece_type == "Knight"
    #   if ((up?(new_y) && y_distance > 1) || (down?(new_y) && y_distance > 1) ||
    #   (left?(new_x) && x_distance > 1) || (right?(new_x) && x_distance > 1 ))
    #     return true
    #   elsif !(up?(new_y) || down?(new_y) || left?(new_x) || right?(new_x))
    #     return true
    #   else
    #   end
    # end


    if up?(new_y)
      # for current y + 1 up to new_y - 1, check for obstructions
      for i in current_piece.y_position+1..new_y-1 do 
        if game.pieces.find_by(x_position: new_x, y_position: i) != nil
          return true
        end
      end
    elsif down?(new_y)
      for i in new_y+1..current_piece.y_position-1 do 
        if game.pieces.find_by(x_position: new_x, y_position: i) != nil
          return true
        end
      end
    elsif left?(new_x)
      for i in new_x+1..current_piece.x_position-1 do 
        if game.pieces.find_by(x_position: i, y_position: new_y) != nil
          return true
        end
      end
    elsif right?(new_x)
      for i in current_piece.x_position+1..new_x-1 do 
        if game.pieces.find_by(x_position: i, y_position: new_y) != nil
          puts "Square #{i},#{new_y} is not nil"
          return true
        end
      end
    elsif diagonal?(x_distance, y_distance)
      if new_x > current_piece.x_position && new_y < current_piece.y_position
        # Northeast move
        for j in new_y+1..current_piece.y_position-1 do 
          for i in current_piece.x_position+1..new_x-1 do
            if game.pieces.find_by(x_position: i, y_position: j) != nil
              return true
            end
          end
        end
      elsif new_x > current_piece.x_position && new_y > current_piece.y_position
        # Southeast move
        for j in current_piece.y_position+1..new_y-1 do 
          for i in current_piece.x_position+1..new_x-1 do
            if game.pieces.where(x_position: i, y_position: j) != nil
              return true
            end
          end
        end

      elsif new_x < current_piece.x_position && new_y < current_piece.y_position
        # Northwest move
        for j in new_y+1..current_piece.y_position-1 do 
          for i in new_x+1..current_piece.x_position-1 do
            if game.pieces.where(x_position: i, y_position: j) != nil
              return true
            end
          end
        end
      else
        # Southwest move
        for j in current_piece.y_position+1..new_y-1 do
          for i in new_x+1..current_piece.x_position-1 do
            if game.pieces.where(x_position: i, y_position: j) != nil
              return true
            end
          end
        end

      end
    else
      # If not a knight and not a N/S/E/W move, it's not valid so return true for now
      return true
    end

    return false

    # places_between = [ [new_x, new_y] ]
    # back_to_start = false
    # current_position = [current_piece.x_position, current_piece.y_position]

    # until back_to_start
    #   if new_x > current_piece.x_position
    #     new_x = new_x - 1
    #   elsif new_x < current_piece.x_position
    #     new_x = new_x + 1
    #   end

    #   if new_y > current_piece.y_position
    #     new_y = new_y -  1
    #   elsif new_y < current_piece.y_position
    #     new_y = new_y + 1
    #   end

    #   if current_position == [new_x, new_y]
    #     back_to_start = true
    #   else
    #     if x_distance == y_distance
    #       places_between << [new_x, new_y]
    #     elsif x_distance == 0
    #       places_between << [current_piece.x_position, new_y]
    #     else
    #       places_between << [new_x, current_piece.y_position]
    #     end
    #   end
    # end
    
    # pieces = self.game.pieces.to_a
    
    # all_pieces_positions = pieces.map { |p| [p.x_position, p.y_position] }
    
    # obstruction = false
    # all_pieces_positions.each do |piece_position|
    #   is_current_piece = current_position == piece_position
    #   is_destination_piece = piece_position == [new_x, new_y]  

    #   if x_distance == 0 && y_distance == 0
    #     obstruction = true
    #   end

    #   if places_between.include?(piece_position) && !is_current_piece && !is_destination_piece       
    #     obstruction = true
    #     break
    #   end   
    # end
    # return obstruction

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
  def up?(new_y_position)
    (self.y_position - new_y_position.to_i) > 0
  end

  # returns true if piece is moving from top to bottom
  def down?(new_y_position)
    (self.y_position - new_y_position.to_i) < 0
  end

  # returns true if piece is moving from right to left
  def left?(new_x_position)
    (self.x_position - new_x_position.to_i) > 0
  end

  # returns true if piece is moving from left to right
  def right?(new_x_position)
    puts "right? is #{(self.x_position - new_x_position.to_i) < 0}"
    (self.x_position - new_x_position.to_i) < 0
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
      puts "*********** INCORRECT TURN **************"
      return false
    elsif is_obstructed?(new_x, new_y)
      puts "*********** IS OBSTRUCTED **************"
      return false
    else
      if !verify_valid_move(new_x, new_y)
        puts "*********** NOT A VALID MOVE **************"
         return false
      else
        # if !king_not_moved_to_check_or_king_not_kept_in_check?
        #   puts "*********** KING MOVED OR KEPT IN CHECK **************"
        #    return false
        # else
          dead_piece = game.pieces.find_by(x_position: new_x, y_position: new_y)
          if dead_piece != nil
            if opposition_piece?(new_x, new_y, id = dead_piece.id, white = dead_piece.white)
              puts "*********** MOVE TO AND CAPTURE **************" 
              move_to_capture_piece_and_capture(dead_piece, new_x, new_y)
              switch_turns
              self.update_attributes(move_number: move_number+1)
            else
              return false
            end
          else
            if (self.piece_type == "King" && (new_x - self.x_position).abs == 2 && self.legal_to_castle?(new_x, new_y) )
              puts "*********** CASTLING ************"
              self.castle(new_x, new_y)
              switch_turns
              # Don't update move number since castle already does that
            elsif (self.piece_type == "Pawn" && en_passant?(new_x,new_y))
              dead_piece = find_capture_piece(new_x, new_y)
              move_to_capture_piece_and_capture(dead_piece, new_x, new_y)
              switch_turns
              self.update_attributes(move_number: move_number+1)
            else
              puts "*********** MOVE TO EMPTY SQUARE **************"
              move_to_empty_square(new_x, new_y)
              switch_turns
              self.update_attributes(move_number: move_number+1)
            end
          end
        #end
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

## code from controller.

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
    # if !self.valid_move?(new_x, new_y, self.id, self.white == true)
    #   puts "***** VALID_MOVE? FALSE **********"
    # end
    # if !(self.is_obstructed?(new_x, new_y) == false)
    #   puts "****** IS OBSTRUCTED ******"
    # end
    # if (self.contains_own_piece?(new_x, new_y) == false)
    #   puts "******* CONTAINS OWN PIECE *********"
    # end
    # if !(king_not_moved_to_check_or_king_not_kept_in_check? == true)  
    #   puts "********  KING MOVED TO OR KEPT IN CHECK ********"
    # end  
    if self.valid_move?(new_x, new_y, self.id, self.white == true) &&
      (self.is_obstructed?(new_x, new_y) == false) &&
      (self.contains_own_piece?(new_x, new_y) == false) ||
      # &&
      # (king_not_moved_to_check_or_king_not_kept_in_check? == true) ||
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

  # def is_captured
  #   capture_piece = self.find_capture_piece(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
  #   if !capture_piece.nil?
  #     self.remove_piece(capture_piece)
  #   end
  # end

  def king_not_moved_to_check_or_king_not_kept_in_check?
    #function checks if player is not moving king into a check position
    #and also checking that if king is in check, player must move king out of check,
    #this function restricts any other random move if king is in check.
    #binding.pry
    king = self.game.pieces.where(:piece_type =>"King").where(:player_id => self.game.turn_player_id)[0]
    if self.piece_type == "King"
      if self.check?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, self.id, self.white == true).blank?
        king.king_check = 0
        return true
      else
        return false
      end
    elsif self.piece_type != "King" && king.king_check == 1
      if ([[piece_params[:x_position].to_i, piece_params[:y_position].to_i]] & king.check?(king.x_position, king.y_position).build_obstruction_array(king.x_position, king.y_position)).count == 1 ||
        (self.valid_move?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, self.id, self.white == true) == true &&
        king.check?(king.x_position, king.y_position).x_position == piece_params[:x_position].to_i &&
        king.check?(king.x_position, king.y_position).y_position == piece_params[:y_position].to_i)
        king.king_check = 0 
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def update_moves(new_x, new_y)
    self.x_position = new_x
    self.y_position = new_y
    self.save
  end

  
end
