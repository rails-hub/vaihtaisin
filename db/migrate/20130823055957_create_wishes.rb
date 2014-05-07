class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.references 	:user
      t.integer 	:offer_id  # => location_id
      t.datetime 	:valid_until

      t.timestamps
    end
  end
end
