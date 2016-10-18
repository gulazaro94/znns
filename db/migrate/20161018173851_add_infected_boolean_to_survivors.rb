class AddInfectedBooleanToSurvivors < ActiveRecord::Migration[5.0]
  def change
    add_column :survivors, :infected, :boolean, default: false
  end
end
