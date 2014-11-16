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
  validates :longitude, :latitude, presence: true
  validates_with NullCheck
  geocoded_by :location
  after_create :forbidden_check, :proximity_score, :set_response_object

  def forbidden_check
    response = HTTParty.get(self.thumbnail_url)
      if response.code == 403
        self.forbidden = true
      else
        self.forbidden = false
      end
    self.save
  end

  def location
    [latitude.to_f, longitude.to_f]
  end

  def self.prox_the_entries
    c=0
    ordered_entries = Entry.all.sort_by(&:updated_at)
    ordered_entries.each do |entry|
      entry.proximity_score
      c +=1
      p "#{c} done" if c % 2000 == 0
    end
  end

  def proximity_score
    nearby_entries_count = Entry.near(self.location, 0.5).count
    self.update_attribute(:prox, nearby_entries_count)
  end

  def set_response_object
    response_object = self.response_object_hash
    self.update_attribute(:response_object, response_object)
  end

  def response_object_hash
    {
      lat: self.latitude,
      lng: self.longitude,
      prox: self.prox,
      url: self.url,
      thumb: self.thumbnail_url
    }
  end

  def self.serialize_the_entries
    c=0
    ordered_entries = Entry.all.sort_by(&:updated_at)
    ordered_entries.each do |entry|
      entry.set_response_object
      c += 1
      if c % 5000 == 0
        p entry.response_object
        p "#{c} done"
      end
    end
  end

  def self.chase_tag(tag)
    Entry.ingest(Instagram.tag_recent_media(URI.escape(tag)))
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
    tag = URI.escape(tag)
    if query_tag.next_max_tag_id.nil?
      hoover_ingest(Instagram.tag_recent_media(URI.escape(tag)), query_tag)
    end
    30.times do |n|
      next_id = query_tag.next_max_tag_id
      p "This is the max id: #{next_id}"
      hoover_ingest(Instagram.tag_recent_media(URI.escape(tag), :max_id => next_id), query_tag)
      p 'another page done'
    end
  end

  def self.prepare_for_launch(lat, lng)
    zoning = lat.to_s + "+" + lng.to_s
    if feed = $redis.get("#{zoning}")
      return feed
    else
      new_feed = Entry.generate_feed_JSON(lat.to_i, lng.to_i)
    end

    if new_feed
      $redis.set("#{zoning}", new_feed)
      expire_time = Time.now.to_i + 72.hours
      $redis.expireat("#{zoning}", expire_time)
    end
    new_feed
  end

  def self.generate_feed_JSON(lat, lng)
    feed = []
    start_lat = lat-1
    finish_lat = lat+1
    start_lng = lng-1.5
    finish_lng = lng+1.5
    sql_query = "latitude >= ? AND latitude <= ? AND longitude >= ? AND longitude <= ? AND prox >= ? AND created_at >= ? AND forbidden = ?"

    Entry.where(sql_query, start_lat, finish_lat, start_lng, finish_lng, 5, 24.months.ago, false).find_each do |entry|
      feed << entry.response_object
    end
    feed.sample(4000).to_json
  end

  def self.random_images(this_many)
    images = []
    until images.count == this_many do
      find_image = rand(80000)
      record = Entry.find_by(id: find_image)
      if record && record.forbidden == false
        url = record.url
        full_image_url = record.full_image_url
        images << [ full_image_url, url ]
      end
    end
    images
  end

  def self.broken_image_begone
    Entry.where("forbidden != ?", false).find_each do |entry|
      response = HTTParty.get(entry.thumbnail_url)
      if response.code == 403
        entry.forbidden = true
        entry.save
      end
    end
  end

end

