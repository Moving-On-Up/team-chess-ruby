# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
    @current_user = current_user
  end
end
