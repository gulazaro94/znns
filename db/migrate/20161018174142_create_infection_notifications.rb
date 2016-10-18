class CreateInfectionNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :infection_notifications do |t|
      t.references :survivor, index: true
      t.integer :infected_id, index: true
      t.timestamps
    end
  end
end
