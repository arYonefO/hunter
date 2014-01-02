class IndexingEverything < ActiveRecord::Migration
  def change
    add_index :entries, :lat
    add_index :entries, :lng
    add_index :tags, :label, unique: true
    add_index :entries, :posted_at
    add_index :entries, :created_at
  end
end
