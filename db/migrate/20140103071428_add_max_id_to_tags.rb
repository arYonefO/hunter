class AddMaxIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :next_max_tag_id, :integer
    add_index :tags, :next_max_tag_id
  end
end
