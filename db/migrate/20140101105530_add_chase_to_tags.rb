class AddChaseToTags < ActiveRecord::Migration
  def change
    add_column :tags, :chase, :boolean, default: false
  end
end
