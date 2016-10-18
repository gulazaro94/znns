class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :survivor, foreign_key: true, index: true
      t.integer :kind, limit: 1
      t.integer :quantity

      t.timestamps
    end
  end
end
