class ResponseObject < ActiveRecord::Migration
  def change
    add_column :entries, :response_object, :hstore
  end

  def up
    add_index :entries, [:response_object], name: "entries_response_object", using: :gin
  end

  def down
    remove_index :entries, name: "entries_response_object"
  end
end
