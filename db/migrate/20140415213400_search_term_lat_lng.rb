class SearchTermLatLng < ActiveRecord::Migration
  def change
    add_column :search_terms, :lat, :integer
    add_column :search_terms, :lng, :integer
  end
end
