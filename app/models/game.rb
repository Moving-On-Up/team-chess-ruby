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


  def check
    pieces.reload
    black_king = pieces.find_by(type: 'King', color: 'black')
    white_king = pieces.find_by(type: 'King', color: 'white')
    pieces.each do |piece|
      return 'black' if piece.valid_move?(black_king.x_position, black_king.y_position) && piece.color == 'white' && piece.captured == false
      return 'white' if piece.valid_move?(white_king.x_position, white_king.y_position) && piece.color == 'black' && piece.captured == false
    end
    nil
  end

  def no_legal_next_move?
    friendly_pieces = pieces.where(color: player_turn, captured: false)
    friendly_pieces.each do |piece|
      (1..8).each do |x|
        (1..8).each do |y|
          if piece.valid_move?(x, y)
            original_x = piece.x_position
            original_y = piece.y_position
            captured_piece = pieces.find_by(x_position: x, y_position: y)
            begin
              captured_piece.update(x_position: -1, y_position: -1) if captured_piece
              piece.update(x_position: x, y_position: y)
              reload
              check_state = check
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

  def end_game_checkmate
    puts "player turn #{player_turn}"
    winning_player_color = player_turn == 'white' ? 'black' : 'white'
    puts "winning player color #{winning_player_color}"
    winning_id = winning_player_color == 'white' ? white_player_id : black_player_id
    puts "winning id #{winning_id}"
    update(winning_player_id: winning_id)
    update(outcome: 'checkmate')
    update(finished: Time.now)
    game_played!
    update_elo!(player_turn)
  end


  def end_game_stalemate
    update(outcome: 'stalemate')
    update(finished: Time.now)
    game_played!
    update_elo!(player_turn)
  end
  
end
