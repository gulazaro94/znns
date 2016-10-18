class CreateSurvivors < ActiveRecord::Migration[5.0]
  def change
    create_table :survivors do |t|
      t.string :name, limit: 150
      t.integer :age, limit: 1
      t.boolean :gender
      t.decimal :last_location_lat, precision: 9, scale: 6
      t.decimal :last_location_lon, precision: 9, scale: 6

      t.timestamps
    end
  end
end