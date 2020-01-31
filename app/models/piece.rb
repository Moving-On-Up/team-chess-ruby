class Piece < ApplicationRecord

  belongs_to :user, required: false
  belongs_to :game

  self.inheritance_column = :type
    
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

  def is_obstructed(x_end, y_end)
    obstruction_array = build_obstruction_array(x_end, y_end)
    # Check if end square contains own piece and if any of in between squares have a piece of any colour in
    obstruction_array.any?{|square| game.contains_piece?(square[0], square[1]) == true}
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

  #def capturable(capture_piece)
  #  (capture_piece.present? && capture_piece.color != color)
  #end

  def find_capture_piece(x_end, y_end)
    if self.type == "Pawn"
      if en_passant?(x_end, y_end)
        game.pieces.where(y_position: y_position, x_position: x_end, type: "Pawn").first
      else
        game.pieces.find_by(x_position: x_end, y_position: y_end)
      end
    else
      game.pieces.where(x_position: x_end, y_position: y_end).first
    end
  end

  #def move_to_capture_piece_and_capture(dead_piece, x_end, y_end)
  #  update_attributes(x_position: x_end, y_position: y_end)
  #  remove_piece(dead_piece)
  #end

  #def capture(capture_piece)
  #  move_to_empty_square(capture_piece.x_position, capture_piece.y_position)
#    remove_piece(capture_piece)
  #end

  def remove_piece(dead_piece)
      dead_piece.update_attributes(x_position: nil, y_position: nil, captured: true) ##Should we have a piece status to add to db? Like captured/in play? This would be helpful for stats also
  end

  #def move_to_empty_square(x_end, y_end)
  #  update_attributes(x_position: x_end, y_position: y_end)
  #end

  def update_winner
    game.update_attributes(state: "end")
    if white?
      game.update_attributes(winner_user_id: game.black_player_user_id)
    else
      game.update_attributes(winner_user_id: game.white_player_user_id)
    end
  end

  def update_loser
    game.update_attributes(state: "end")
    if white?
      game.update_attributes(loser_user_id: game.black_player_user_id)
    else
      game.update_attributes(loser_user_id: game.white_player_user_id)
    end
  end

  def name
    "#{self.type}_#{self.white ? 'white' : 'black' }"
  end
end
