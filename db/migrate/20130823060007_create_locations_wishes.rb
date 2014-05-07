class CreateLocationsWishes < ActiveRecord::Migration
  def change
    create_table :locations_wishes do |t|
      t.references :location, :wish
    end

    add_index :locations_wishes, [:location_id, :wish_id],
      name: "locations_wishes_index",
      unique: true
  end
end
