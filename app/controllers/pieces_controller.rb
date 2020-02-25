class PiecesController < ApplicationController
  respond_to :html, :json

  def respond_to(&block)
    responder = Responder.new(self)
    block.call(responder)
    responder.respond
  end
  
end
