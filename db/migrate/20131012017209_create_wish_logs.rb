class CreateWishLogs < ActiveRecord::Migration
  def change
    create_table :wish_logs do |t|
      t.integer :wish_by_id
      t.integer :wish_match_id
      t.string :status
      t.timestamps
    end
  end
end
