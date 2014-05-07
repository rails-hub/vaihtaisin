class CreateTravelPreferences < ActiveRecord::Migration
  def change
    create_table :travel_preferences do |t|
      t.references :user
      t.boolean :car
      t.boolean :foot
      t.boolean :bicycle
      t.timestamps
    end
  end
end
