class AddColumnsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :lat, :decimal, {:precision=>10, :scale=>7}
    add_column :entries, :lng, :decimal, {:precision=>10, :scale=>7}
  end
end
