FactoryGirl.define do
  factory :entry do
    sequence(:url)         { |n| "www.instaexample.com/example/34#{n}" }
    sequence(:longitude)   { |n| -122.437477 + (n*0.00001) }
    sequence(:latitude)    { |n|   37.771122 + (n*0.00001) }
    likes                  7
    thumbnail_url          "www.instaexample.com/7yadsgf98yad/"
    full_image_url         "www.instaexample.com/11346524sdfh/"
  end

  factory :tag do
    label         "graffiti"
    chase         false
  end

  factory :search_term do
    search_term     "Paris, France"
  end
end