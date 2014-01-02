class RemoveStringLatLon < ActiveRecord::Migration
  def change
    remove_columns(:entries, :longitude, :latitude)
  end
end
