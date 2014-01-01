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
end