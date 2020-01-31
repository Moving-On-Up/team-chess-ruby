class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_games
  has_many :games
  has_many :pieces

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }
end
