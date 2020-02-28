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
    piece.present? && piece.white == white
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
   current_piece = self
    @game = self.game
    
    x_distance = current_piece.x_position - new_x
    y_distance = current_piece.y_position - new_y

    if !(((x_distance == y_distance) || (x_distance == 0) || (y_distance == 0)))
      return nil
    end

    places_between = [ [new_x, new_y] ]
    back_to_start = false
    current_position = [current_piece.x_position, current_piece.y_position]

    until back_to_start
      if new_x > current_piece.x_position
        new_x = new_x - 1
      elsif new_x < current_piece.x_position
        new_x = new_x + 1
      end

      if new_y > current_piece.y_position
        new_y = new_y -  1
      elsif new_y < current_piece.y_position
        new_y = new_y + 1
      end

      if current_position == [new_x, new_y]
        back_to_start = true
      else
        if x_distance == y_distance
          places_between << [new_x, new_y]
        elsif x_distance == 0
          places_between << [current_piece.x_position, new_y]
        else
          places_between << [new_x, current_piece.y_position]
        end
      end
    end
    
    pieces = self.game.pieces.to_a
    
    all_pieces_positions = pieces.map { |p| [p.x_position, p.y_position] }
    
    obstruction = false
    all_pieces_positions.each do |piece_position|
      is_current_piece = current_position == piece_position
      is_destination_piece = piece_position == [new_x, new_y]  

      if x_distance == 0 && y_distance == 0
        obstruction = true
      end

      if places_between.include?(piece_position) && !is_current_piece && !is_destination_piece       
        obstruction = true
        break
      end   
    end
    return obstruction
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
    x_distance = (new_x_position - x_position).abs
  end

  # determines vertical distance travelled by piece
  def y_distance(new_y_position)
    y_distance = (new_y_position - y_position).abs
  end

  # returns true if piece is moving from bottom to top
  def up?(new_y_position)
    (y_position - new_y_position) > 0
  end

  # returns true if piece is moving from top to bottom
  def down?(new_y_position)
    (y_position - new_y_position) < 0
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
        game.pieces.where(y_position: y_position, x_position: x_end, piece_type: "Pawn").first
      else
        game.pieces.find_by(x_position: x_end, y_position: y_end)
      end
    else
      game.pieces.where(x_position: x_end, y_position: y_end).first
    end
  end

  def move_to!(new_x,new_y)
    a_piece = Piece.find_by(x_position: new_x, y_position: new_y)
    if a_piece != nil
      remove_piece(a_piece)
    end
    self.x_position = new_x
    self.y_position = new_y
    self.save
  end

  def move_to_capture_piece_and_capture(dead_piece, x_end, y_end)
    update_attributes(x_position: x_end, y_position: y_end)
    remove_piece(dead_piece)
  end

  def capture(capture_piece)
    move_to_empty_square(capture_piece.x_position, capture_piece.y_position)
    remove_piece(capture_piece)
  end

  def remove_piece(dead_piece)
      dead_piece.update_attributes(x_position: nil, y_position: nil) ##Should we have a piece status to add to db? Like captured/in play? This would be helpful for stats also
  end

  def move_to_empty_square(x_end, y_end)
    update_attributes(x_position: x_end, y_position: y_end)
  end

  def update_winner
    game.update_attributes(state: "end")
    if white?
      game.update_attributes(winner_user_id: game.black_player_id)
    else
      game.update_attributes(winner_user_id: game.white_player_id)
    end
  end

  def update_loser
    game.update_attributes(state: "end")
    if white?
      game.update_attributes(loser_user_id: game.black_player_id)
    else
      game.update_attributes(loser_user_id: game.white_player_id)
    end
  end

  def name
    "#{self.piece_type}_#{self.white ? 'white' : 'black' }"
  end

## code from controller.

  def update
    @game = self.game
    current_piece = self
    is_captured
    #if piece_params[:piece][:piece_type] == "Queen" || 
    if self.piece_params[:piece_type] == "Queen" || 
       self.piece_params[:piece_type] == "Bishop" || 
       self.piece_params[:piece_type] == "Knight" || 
       self.piece_params[:piece_type] == "Rook"
      self.update_attributes(piece_type: self.piece_params[:piece_type])
    elsif self.piece_type == "King" && 
          self.legal_to_castle?(self.piece_params[:x_position].to_i, self.piece_params[:y_position].to_i)
      self.castle(self.piece_params[:x_position].to_i, self.piece_params[:y_position].to_i)
    else
      self.update_attributes(move_number: self.move_number + 1)
    end

    #Below king_opp mean the opponent's player's king. After the player's turn,
    #we'd like to know if the opponent king is in check, and if in check, does
    #the opponent's king have any way to get out of check (see check_mate in king.rb)
    #if the opponent's king is stuck, the game is over, right now noted by the 401 error

    king_opp = @game.pieces.where(:piece_type =>"King").where.not(:player_id => @game.turn_player_id)[0]
    king_current = @game.pieces.where(:piece_type =>"King").where(:player_id => @game.turn_player_id)[0]
    game_end = false
    if king_opp.check?(king_opp.x_position, king_opp.y_position).present?
      if king_opp.find_threat_and_determine_checkmate
        king_opp.update_winner
        king_current.update_loser
        game_end = true
      else
        king_opp.update_attributes(king_check: 1)
      end
    elsif king_opp.stalemate?
      @game.update_attributes(state: "end")
      game_end = true
    end
    if game_end == false && !(self.piece_type == "Pawn" && self.pawn_promotion?)
      update_moves
      switch_turns
      self.status = 200
    else
      self.status = 201
    end
    self.save
  end

  #private

  def verify_two_players
    return if @game.black_player_id && @game.white_player_id
    self.status = 422
    #respond_to do |format|
    #  format.any {render :json => { :response => "Need to wait for second player!", class: "alert alert-warning"}, :status => 422}
    #end
  end

  def switch_turns
    if @game.white_player_id == @game.turn_player_id
      @game.update_attributes(turn_player_id:@game.black_player_id)
    elsif @game.black_player_id == @game.turn_player_id
      @game.update_attributes(turn_player_id:@game.white_player_id)
    end
  end

  def find_piece
    piece = self.id
    @game = self.game
  end

  def verify_valid_move
    return if self.valid_move?(self.x_position.to_i, self.y_position.to_i, self.id, self.white == true) &&
    (self.is_obstructed?(self.x_position.to_i, self.y_position.to_i) == false) &&
    (self.contains_own_piece?(self.x_position.to_i, self.y_position.to_i) == false) &&
    (king_not_moved_to_check_or_king_not_kept_in_check? == true) ||
    self.piece_type == "Pawn" && self.pawn_promotion?
    self.status = 422
    #respond_to do |format|
    #  format.any {render :json => { :response => "Invalid move!", class: "alert alert-warning"}, :status => 422}
    #end
  end

  def verify_player_turn
    return if correct_turn? &&
    ((self.game.white_player_id == self.player_id && self.white?) ||
    (self.game.black_player_id == self.player_id && self.black?))
    self.status = 422
    #respond_to do |format|
    # format.any {render :json => { :response => "Not yet your turn!", class: "alert alert-warning"}, :status => 422}
    #end
  end

  def correct_turn?
    self.game.turn_player_id == self.player_id
  end

  def piece_params
    piece = self
    #params.require(:piece).permit(:x_position, :y_position, :captured, :white, :id, :piece_type)
    return params = {piece: "piece", x_position: "self.x_position", y_position: "self.y_position", captured: "self.captured", white: "self.white", id: "self.id", piece_type: "self.piece_type"}
  end

  def is_captured
    capture_piece = self.find_capture_piece(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
    if !capture_piece.nil?
      self.remove_piece(capture_piece)
    end
  end

  def king_not_moved_to_check_or_king_not_kept_in_check?
    #function checks if player is not moving king into a check position
    #and also checking that if king is in check, player must move king out of check,
    #this function restricts any other random move if king is in check.

    king = @game.pieces.where(:piece_type =>"King").where(:player_id => @game.turn_player_id)[0]
    if self.piece_type == "King"
      if self.check?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, self.id, self.white == true).blank?
        king.update_attributes(king_check: 0)
        return true
      else
        return false
      end
    elsif self.piece_type != "King" && king.king_check == 1
      if ([[piece_params[:x_position].to_i, piece_params[:y_position].to_i]] & king.check?(king.x_position, king.y_position).build_obstruction_array(king.x_position, king.y_position)).count == 1 ||
        (self.valid_move?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, self.id, self.white == true) == true &&
        king.check?(king.x_position, king.y_position).x_position == piece_params[:x_position].to_i &&
        king.check?(king.x_position, king.y_position).y_position == piece_params[:y_position].to_i)
        king.update_attributes(king_check: 0)
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def update_moves
    self.game.reload
    #Move.create(piece_player_id: self.player_id, piece_type: self.piece_type, x_position: self.x_position, y_position: self.y_position, game_id:@game.id)
  end
end
