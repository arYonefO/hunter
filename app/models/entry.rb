class NullCheck < ActiveModel::Validator
  def validate(record)
    if record.lat == 0 && record.lng == 0
      record.errors[:base] << "Another entry from Null Island"
    end
  end
end

class Entry < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates :url, presence: true, uniqueness: true
  validates :lng, presence: true
  validates :lat, presence: true
  validates_with NullCheck
  geocoded_by :latitude => :lat, :longitude => :lng

  def location
    [lat, lng]
  end


  def self.chase_tag(tag)
    Entry.ingest(Instagram.tag_recent_media(tag))
  end

  def self.chase_user(user)
    user_id = Instagram.user_search(user)[0][:id]
    Entry.ingest(Instagram.user_recent_media(user_id))
  end

  def self.ingest(response)
    reformatted_response = Entry.reformat_datashape(response)
    Entry.put_response_into_database(reformatted_response)
  end

  def self.reformat_datashape(instagram_response)
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

  def self.put_response_into_database(response)
    response.each do |entry|
      entry[:tags].map! do |tag|
        Tag.new(label: tag)
      end
      record = Entry.new(entry)
      record.save
      p "record saved!" if record.save
    end
  end

  def self.clean_them_out(user)
    user_id = Instagram.user_search(user)[0][:id]
    instagram_response = Instagram.user_recent_media(user_id)
    Entry.ingest(instagram_response)
    p next_page_max_id = instagram_response.pagination.next_max_id
    while !next_page_max_id.nil?
      newest_page_response = Instagram.user_recent_media(user_id, :max_id => next_page_max_id )
      Entry.ingest(newest_page_response)
      p "This is the max id: #{next_page_max_id = newest_page_response.pagination.next_max_id}"
      p 'another page'
    end
  end
end