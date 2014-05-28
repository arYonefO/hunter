class EntryForbidden < ActiveRecord::Migration
  def change
    add_column :entries, :forbidden, :boolean
  end
end
