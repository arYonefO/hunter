class NullCheck < ActiveModel::Validator
  def validate(record)
    if record.latitude == 0 && record.longitude == 0
      record.errors[:base] << "Another entry from Null Island"
    end
  end
end

class Entry < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates :url, presence: true, uniqueness: true
  validates :longitude, presence: true
  validates :latitude, presence: true
  validates_with NullCheck
  geocoded_by :location
  after_validation :proximity_score

  def location
    [latitude.to_f, longitude.to_f]
  end

  def self.prox_the_entries
    ordered_entries = Entry.all.sort_by(&:updated_at)
    ordered_entries.each do |entry|
      entry.proximity_score
    end
  end

  def proximity_score
    nearby_entries_count = Entry.near(self.location, 1).count
    self.update_attribute(:prox, nearby_entries_count)
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
    instagram_response.reject!{ |entry| entry[:location].nil? }
    instagram_response.map! do |entry|
      entry_creation_args = {}
      entry_creation_args[:latitude]        = entry[:location][:latitude]
      entry_creation_args[:longitude]       = entry[:location][:longitude]
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
        Tag.where(:label => tag).first_or_create
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
    until next_page_max_id.nil?
      newest_page_response = Instagram.user_recent_media(user_id, :max_id => next_page_max_id )
      Entry.ingest(newest_page_response)
      p "This is the max id: #{next_page_max_id = newest_page_response.pagination.next_max_id}"
      p 'another page done'
    end
  end

  def self.hoover_ingest(instagram_response, query_tag)
    Entry.ingest(instagram_response)
    query_tag.update_attribute(:next_max_tag_id, instagram_response.pagination.next_max_tag_id)
  end

  def self.hoover_tag(tag)
    query_tag = Tag.where(:label => tag).first_or_create
    if query_tag.next_max_tag_id.nil?
      hoover_ingest(Instagram.tag_recent_media(tag), query_tag)
    end
    30.times do |n|
      next_id = query_tag.next_max_tag_id
      p "This is the max id: #{next_id}"
      hoover_ingest(Instagram.tag_recent_media(tag, :max_id => next_id), query_tag)
      p 'another page done'
    end
  end

  def self.prepare_for_launch
    Rails.cache.fetch("regular_prox_entries", :expires_in => 24.hours) do
      feed = []
      Entry.find_in_batches(:batch_size => 1000) do |entries|
        feed + entries.where("prox >= ?", 20)
      end
      feed.to_json
    end
  end

   def self.two_random_images
    Rails.cache.fetch("image_pair", :expires_in => 2.minutes) do
      images = []
      until images.count == 2 do
        find_image = rand(66000)
        record = Entry.find_by(id: find_image)
        if record
          url = record.url
          full_image_url = record.full_image_url
          images << [ full_image_url, url ]
        end
      end
      images
    end
  end

end