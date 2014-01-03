class FixTagId < ActiveRecord::Migration
  def change
    remove_column :tags, :next_max_tag_id
    add_column :tags, :next_max_tag_id, :integer, :limit => 8
  end
end
