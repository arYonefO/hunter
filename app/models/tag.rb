class Tag < ActiveRecord::Base
  has_and_belongs_to_many :entries

  validates :label, presence: true, uniqueness: true
end