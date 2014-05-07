class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :area1
      t.string :area2
      t.string :caretype
      t.string :streetaddress
      t.string :streetnumber
      t.string :pobox
      t.string :zipcode
      t.string :ziparea
      t.string :city
      t.string :phone
      t.string :email
      t.string :supervisor
      t.string :supervisoremail
      t.string :supervisorphone
      t.integer :capacity

      t.timestamps
    end
  end
end
