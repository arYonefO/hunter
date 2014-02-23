class EntriesZoning < ActiveRecord::Migration
  def change
    add_column :entries, :zone, :integer
  end
end
