FactoryBot.define do
  factory :move do
    
  end
  factory :message do
    
  end
  factory :pawn do

  end
  factory :king do

  end
  factory :queen do

  end
  factory :knight do

  end
  factory :bishop do

  end
  factory :rook do

  end
  factory :piece do
    #message { "hello" }
    #picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png') }
    
    #association :user
  end


  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password { "Password" }
    password_confirmation { "Password" }
  end

  factory :game do
   
  end
end

