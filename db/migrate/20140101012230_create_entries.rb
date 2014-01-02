class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :url
      t.string :latitude
      t.string :longitude
      t.integer :likes
      t.string :posted_at
      t.string :thumbnail_url
      t.string :full_image_url

      t.timestamps
    end

    create_table :tags do |t|
      t.string :label

      t.timestamps
    end

    create_table :entries_tags do |t|
      t.belongs_to :entry
      t.belongs_to :tag
    end
  end
end