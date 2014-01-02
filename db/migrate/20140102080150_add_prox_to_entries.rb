class AddProxToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :prox, :integer
  end
end
