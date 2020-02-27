# frozen_string_literal: true

class PiecesController < ApplicationController
  before_action :find_piece, :verify_two_players, :verify_player_turn, :verify_valid_move

  def update
    @game = @piece.game
    is_captured
    if params[:piece][:piece_type] == 'Queen' || params[:piece][:piece_type] == 'Bishop' || params[:piece][:piece_type] == 'Knight' || params[:piece][:piece_type] == 'Rook'
      @piece.update_attributes(piece_type: params[:piece][:piece_type])
    elsif @piece.piece_type == 'King' && @piece.legal_to_castle?(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
      @piece.castle(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
    else
      @piece.update_attributes(piece_params.merge(move_number: @piece.move_number + 1))
    end

    # Below king_opp mean the opponent's player's king. After the player's turn,
    # we'd like to know if the opponent king is in check, and if in check, does
    # the opponent's king have any way to get out of check (see check_mate in king.rb)
    # if the opponent's king is stuck, the game is over, right now noted by the 401 error

    king_opp = @game.pieces.where(piece_type: 'King').where.not(player_id: @game.turn_player_id)[0]
    king_current = @game.pieces.where(piece_type: 'King').where(player_id: @game.turn_player_id)[0]
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
      @game.update_attributes(state: 'end')
      game_end = true
    end
    if game_end == false && !(@piece.piece_type == 'Pawn' && @piece.pawn_promotion?)
      update_moves
      switch_turns
      render json: {}, status: 200
    else
      render json: {}, status: 201
    end
  end

  private

  def verify_two_players
    return if @game.black_player_id && @game.white_player_id

    respond_to do |format|
      format.any { render json: { response: 'Need to wait for second player!', class: 'alert alert-warning' }, status: 422 }
    end
  end

  def switch_turns
    if @game.white_player_id == @game.turn_player_id
      @game.update_attributes(turn_player_id: @game.black_player_id)
    elsif @game.black_player_id == @game.turn_player_id
      @game.update_attributes(turn_player_id: @game.white_player_id)
    end
  end

  def find_piece
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def verify_valid_move
    return if @piece.valid_move?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, @piece.id, @piece.white == true) &&
              (@piece.is_obstructed?(piece_params[:x_position].to_i, piece_params[:y_position].to_i) == false) &&
              (@piece.contains_own_piece?(piece_params[:x_position].to_i, piece_params[:y_position].to_i) == false) &&
              (king_not_moved_to_check_or_king_not_kept_in_check? == true) ||
              # @piece.piece_type == "Pawn" && @piece.pawn_promotion?

              respond_to do |format|
                format.any { render json: { response: 'Invalid move!', class: 'alert alert-warning' }, status: 422 }
              end
  end

  def verify_player_turn
    return if correct_turn? &&
              ((@piece.game.white_player_id == @piece.player_id && @piece.white?) ||
              (@piece.game.black_player_id == @piece.player_id && @piece.black?))

    respond_to do |format|
      format.any { render json: { response: 'Not yet your turn!', class: 'alert alert-warning' }, status: 422 }
    end
  end

  def correct_turn?
    @piece.game.turn_player_id == @piece.player_id
  end

  def piece_params
    params.require(:piece).permit(:x_position, :y_position, :captured, :white, :id, :piece_type)
  end

  def is_captured
    capture_piece = @piece.find_capture_piece(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
    @piece.remove_piece(capture_piece) unless capture_piece.nil?
  end

  def king_not_moved_to_check_or_king_not_kept_in_check?
    # function checks if player is not moving king into a check position
    # and also checking that if king is in check, player must move king out of check,
    # this function restricts any other random move if king is in check.

    king = @game.pieces.where(piece_type: 'King').where(player_id: @game.turn_player_id)[0]
    if @piece.piece_type == 'King'
      if @piece.check?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, @piece.id, @piece.white == true).blank?
        king.update_attributes(king_check: 0)
        true
      else
        false
      end
    elsif @piece.piece_type != 'King' && king.king_check == 1
      if ([[piece_params[:x_position].to_i, piece_params[:y_position].to_i]] & king.check?(king.x_position, king.y_position).build_obstruction_array(king.x_position, king.y_position)).count == 1 ||
         (@piece.valid_move?(piece_params[:x_position].to_i, piece_params[:y_position].to_i, @piece.id, @piece.white == true) == true &&
         king.check?(king.x_position, king.y_position).x_position == piece_params[:x_position].to_i &&
         king.check?(king.x_position, king.y_position).y_position == piece_params[:y_position].to_i)
        king.update_attributes(king_check: 0)
        true
      else
        false
      end
    else
      true
    end
  end

  def update_moves
    @piece.game.reload
    # Move.create(piece_player_id: @piece.player_id, piece_type: @piece.piece_type, x_position: @piece.x_position, y_position: @piece.y_position, game_id:@game.id)
  end
end
