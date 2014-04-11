class RemoveZone < ActiveRecord::Migration
  def change
    remove_column(:entries, :zone)
  end
end
