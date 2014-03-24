class AddSearchTerms < ActiveRecord::Migration
  def change
    create_table :search_terms do |t|
      t.string :search_term
      t.integer :count
      t.string :when, :array => true, default: []

      t.timestamps
    end
  end
end
