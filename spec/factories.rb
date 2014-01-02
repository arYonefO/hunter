FactoryGirl.define do
  factory :entry do
    url             "www.instaexample.com/example/34"
    lng             -122.437477
    lat             37.771122
    likes            7
    thumbnail_url   "www.instaexample.com/7yadsgf98yad/"
    full_image_url  "www.instaexample.com/11346524sdfh/"
  end

  factory :tag do
    label         "graffiti"
  end
end