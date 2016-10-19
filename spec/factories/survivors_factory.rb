FactoryGirl.define do

  factory :survivor do
    name 'Gustavo L. Amendola'
    age 41
    gender 'male'
    last_location_lat -22.224859
    last_location_lon -49.962380

    trait :infected do
      infected true
    end
  end

end