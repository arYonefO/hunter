namespace :db do
  desc "Poll instagram for appropriate data"
  task populate: :environment do
    chase_tag('rsa_graffiti')
    chase_tag('sfx_graffiti')
    chase_user('instagrafite')
  end
end

def chase_tag(tag)
  api_response = Instagram.tag_recent_media(tag)
  reformatted_response = reformat_datashape(api_response)
  put_response_into_database(reformatted_response)
end

def chase_user(user)
  user_id = Instagram.user_search(user)[0][:id]
  api_response = Instagram.user_recent_media(user_id)
  reformatted_response = reformat_datashape(api_response)
  put_response_into_database(reformatted_response)
end

def reformat_datashape(instagram_response)
  instagram_response.reject!{|entry| entry[:location].nil?}
  instagram_response.map! do |entry|
    entry_creation_args = {}
    entry_creation_args[:lat]             = entry[:location][:latitude]
    entry_creation_args[:lng]             = entry[:location][:longitude]
    entry_creation_args[:likes]           = entry[:likes][:count]
    entry_creation_args[:url]             = entry[:link]
    entry_creation_args[:posted_at]       = entry[:created_time]
    entry_creation_args[:thumbnail_url]   = entry[:images][:thumbnail][:url]
    entry_creation_args[:full_image_url]  = entry[:images][:standard_resolution][:url]
    entry_creation_args[:tags]            = entry[:tags]
    entry_creation_args
  end
end

def put_response_into_database(response)
  response.each do |entry|
    entry[:tags].map! do |tag|
      Tag.new(label: tag)
    end
    record = Entry.new(entry)
    record.save
  end
end