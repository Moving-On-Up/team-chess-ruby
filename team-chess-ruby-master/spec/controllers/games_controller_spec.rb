require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#new action" do
    it "should successfully show the page" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # describe "games#create action" do
  #   it "should successfully show the page" do
  #     get :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe "games#show action" do
    it "should successfully show the page" do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

end
