class Game < ApplicationRecord

  scope :available, -> { Game.where(white_player_id: [nil, ""]).or(Game.where(black_player_id: [nil, ""])) }
  scope :active, -> { Game.where(current_status: "active") }
  

  belongs_to :user

  has_many :pieces
  has_many :user_games
  has_many :users, through: :user_games
  has_many :messages
  has_many :moves 

  after_create :lay_out_board!

  def contains_piece?(x_position, y_position)
    if pieces.where("(x_position = ? AND y_position = ?)", x_position, y_position).any?
      return true
    else
      return false
    end
  end

  def lay_out_board!
    # WHITE PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: id, piece_type: "Pawn", white: true, x_position: x_position, y_position: 7, player_id: white_player_id, name: "Pawn_white")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, piece_type: "Rook", white: true, x_position: x_position, y_position: 8, player_id: white_player_id, name: "Rook_white")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, piece_type: "Knight", white: true, x_position: x_position, y_position: 8, player_id: white_player_id, name: "Knight_white")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, piece_type: "Bishop", white: true, x_position: x_position, y_position: 8, player_id: white_player_id, name: "Bishop_white")
      end

      #King
      King.create(game_id: id, piece_type: "King", white: true, x_position: 5, y_position: 8, player_id: white_player_id, name: "King_white")

      #Queen
      Queen.create(game_id: id, piece_type: "Queen", white: true, x_position: 4, y_position: 8, player_id: white_player_id, name: "Queen_white")

    # BLACK PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: id, piece_type: "Pawn", white: false, x_position: x_position, y_position: 2, player_id: black_player_id, name: "Pawn_black")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, piece_type: "Rook", white: false, x_position: x_position, y_position: 1, player_id: black_player_id, name: "Rook_black")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, piece_type: "Knight", white: false, x_position: x_position, y_position: 1, player_id: black_player_id, name: "Knight_black")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, piece_type: "Bishop", white: false, x_position: x_position, y_position: 1, player_id: black_player_id, name: "Bishop_black")
      end

      #King
      King.create(game_id: id, piece_type: "King", white: false, x_position: 5, y_position: 1, player_id: black_player_id, name: "King_black")

      #Queen
      Queen.create(game_id: id, piece_type: "Queen", white: false, x_position: 4, y_position: 1, player_id: black_player_id, name: "Queen_black")
  end

  def white_player
    User.find_by_id(white_player_id)
  end

  def black_player
    User.find_by_id(black_player_id)
  end

 
  def winner
    User.find_by_id(winner_player_id)
  end

  def loser
    User.find_by_id(loser_player_id)
  end

  def checkmate?(white)
    return false unless check?(white)
    return false if valid_move(white) 
    true
  end

  def valid_move(white)
    valid_move = []
    playable_pieces(white).each do |piece|
      (0..7).each do |y|
        (0..7).each do |x|
          next if !piece.valid_move?(x,y)
          next if piece.puts_self_in_check?(x,y)
          valid_move << piece
        end
      end
    end
    return valid_move.present?
  end

  def check
    pieces.reload
    black_king = pieces.find_by(piece_type: 'King', player_id: black_player_id)
    white_king = pieces.find_by(piece_type: 'King',player_id: white_player_id)
    pieces.each do |piece|
      return 'black' if piece.valid_move?(black_king.x_position, black_king.y_position) && piece.color == 'white' && piece.is_captured == false
      return 'white' if piece.valid_move?(white_king.x_position, white_king.y_position) && piece.color == 'black' && piece.is_captured == false
    end
    nil
  end



  def no_legal_next_move?
    if white_player.piece.valid_move? == false
      return false
    elsif black_player.piece.valid_move? == false
      return false
    end   
  end

  def checkmate
    if !check.nil?
      return true if no_legal_next_move?
    end
    false
  end

  def stalemate
    if check.nil?
      return true if no_legal_next_move?
    end
    false
  end
  
  def is_captured
    capture_piece = self.find_capture_piece(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
    if !capture_piece.nil?
      self.remove_piece(capture_piece)
    end
  end  

  def find_capture_piece(x_end, y_end)
    if self.piece_type == "Pawn"
      if en_passant?(x_end, y_end)
        pieces.where(y_position: y_position, x_position: x_end, piece_type: "Pawn").first
      else
        pieces.find_by(x_position: x_end, y_position: y_end)
      end
      else
       pieces.where(x_position: x_end, y_position: y_end).first
    end
  end
 
 
  def remove_piece(dead_piece)
    dead_piece.x_position = nil
    dead_piece.y_position = nil
    dead_piece.save
  end

end
