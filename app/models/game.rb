class Game < ApplicationRecord
  scope :available, -> { Game.where(white_player_id: [nil, ""]).or(Game.where(black_player_id: [nil, ""])) }
  
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
        Pawn.create(game_id: id, white: true, x_position: x_position, y_position: 7, user_id: white_player_user_id, name: "Pawn_white")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, white: true, x_position: x_position, y_position: 8, user_id: white_player_user_id, name: "Rook_white")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, white: true, x_position: x_position, y_position: 8, user_id: white_player_user_id, name: "Knight_white")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, white: true, x_position: x_position, y_position: 8, user_id: white_player_user_id, name: "Bishop_white")
      end

      #King
      King.create(game_id: id, white: true, x_position: 5, y_position: 8, user_id: white_player_user_id, name: "King_white")

      #Queen
      Queen.create(game_id: id, white: true, x_position: 4, y_position: 8, user_id: white_player_user_id, name: "Queen_white")

    # BLACK PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: id, white: false, x_position: x_position, y_position: 2, user_id: black_player_user_id, name: "Pawn_black")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, white: false, x_position: x_position, y_position: 1, user_id: black_player_user_id, name: "Rook_black")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, white: false, x_position: x_position, y_position: 1, user_id: black_player_user_id, name: "Knight_black")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, white: false, x_position: x_position, y_position: 1, user_id: black_player_user_id, name: "Bishop_black")
      end

      #King
      King.create(game_id: id, white: false, x_position: 5, y_position: 1, user_id: black_player_user_id, name: "King_black")

      #Queen
      Queen.create(game_id: id, white: false, x_position: 4, y_position: 1, user_id: black_player_user_id, name: "Queen_black")
  end


  def white_player
    User.find_by_id(white_player_user_id)
  end

  def black_player
    User.find_by_id(black_player_user_id)
  end

  def winner
    User.find_by_id(winner_user_id)
  end

  def loser
    User.find_by_id(loser_user_id)
  end


end
