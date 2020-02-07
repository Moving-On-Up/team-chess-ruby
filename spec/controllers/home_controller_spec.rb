require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "home#index action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user)
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end
  end
<<<<<<< HEAD

  #describe "home#index action" do
  #  it "should successfully show the page" do
  #    get :index
  #   expect(response).to have_http_status(:success)
  #  end
  #end
=======
>>>>>>> a6396816c798e4955980840ebdc59aca2528a829

  #describe "home#index action" do
  #  it "should successfully show the page" do
  #    get :index
  #   expect(response).to have_http_status(:success)
  #  end
  #end
end
