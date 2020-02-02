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
        Pawn.create(game_id: id, white: true, x_position: x_position, y_position: 7, player_id: white_player_id, name: "Pawn_white")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, white: true, x_position: x_position, y_position: 8, player_id: white_player_id, name: "Rook_white")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, white: true, x_position: x_position, y_position: 8, player_id: white_player_id, name: "Knight_white")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, white: true, x_position: x_position, y_position: 8, player_id: white_player_id, name: "Bishop_white")
      end

      #King
      King.create(game_id: id, white: true, x_position: 5, y_position: 8, player_id: white_player_id, name: "King_white")

      #Queen
      Queen.create(game_id: id, white: true, x_position: 4, y_position: 8, player_id: white_player_id, name: "Queen_white")

    # BLACK PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: id, white: false, x_position: x_position, y_position: 2, player_id: black_player_id, name: "Pawn_black")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, white: false, x_position: x_position, y_position: 1, player_id: black_player_id, name: "Rook_black")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, white: false, x_position: x_position, y_position: 1, player_id: black_player_id, name: "Knight_black")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, white: false, x_position: x_position, y_position: 1, player_id: black_player_id, name: "Bishop_black")
      end

      #King
      King.create(game_id: id, white: false, x_position: 5, y_position: 1, player_id: black_player_id, name: "King_black")

      #Queen
      Queen.create(game_id: id, white: false, x_position: 4, y_position: 1, player_id: black_player_id, name: "Queen_black")
  end


  def white_player
    User.find_by_id(white_player_id)
  end

  def black_player
    User.find_by_id(black_player_id)
  end

  
 

 def is_obstructed?(white_player, black_player, new_x, new_y)
   current_piece = Piece.find(white_player, black_player)

    x_diff = current_piece.x_coord - new_x
    y_diff = current_piece.y_coord - new_y

    if !(((x_diff == y_diff) || (x_diff == 0) || (y_diff == 0)))
      return nil
    end

    places_between = [ [new_x, new_y] ]
    back_to_start = false
    current_coordinates = [current_piece.x_coord, current_piece.y_coord]

    until back_to_start
      if new_x > current_piece.x_coord
        new_x = new_x - 1
      elsif new_x < current_piece.x_coord
        new_x = new_x + 1
      end

      if new_y > current_piece.y_coord
        new_y = new_y -  1
      elsif new_y < current_piece.y_coord
        new_y = new_y + 1
      end

      if current_coordinates == [new_x, new_y]
        back_to_start = true
      else
        if x_diff == y_diff
          places_between << [new_x, new_y]
        elsif x_diff == 0
          places_between << [current_piece.x_coord, new_y]
        else
          places_between << [new_x, current_piece.y_coord]
        end
      end
    end
    
    pieces = self.pieces.to_a
    
    all_piece_coordinates = pieces.map { |p| [p.x_coord, p.y_coord] }
    
    obstruction = false
    all_piece_coordinates.each do |piece_coordinates|
      is_current_piece = current_coordinates == piece_coordinates
      is_destination_piece = piece_coordinates == [new_x, new_y]  

      if x_diff == 0 && y_diff == 0
        obstruction = true
      end

      if places_between.include?(piece_coordinates) && !is_current_piece && !is_destination_piece       
        obstruction = true
        break
      end   
    end
    return obstruction
  end


  
  def winner
    User.find_by_id(winner_player_id)
  end

  def loser
    User.find_by_id(loser_player_id)
  end
  
end
