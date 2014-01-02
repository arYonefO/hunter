class AddCompositeIndex < ActiveRecord::Migration
  def change
    add_index :entries, [:lat, :lng]
  end
end
