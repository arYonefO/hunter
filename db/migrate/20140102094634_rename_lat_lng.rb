class RenameLatLng < ActiveRecord::Migration
  def change
    rename_column :entries, :lat, :latitude
    rename_column :entries, :lng, :longitude
  end
end
