class Entry < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates :url, presence: true, uniqueness: true
  validates :lng, presence: true
  validates :lat, presence: true
end