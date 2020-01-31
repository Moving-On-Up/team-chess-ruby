class Game < ApplicationRecord
  scope :available, -> { Game.where(white_player_id: [nil, ""]).or(Game.where(black_player_id: [nil, ""])) }
  
  belongs_to :user
end
