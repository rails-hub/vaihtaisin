class CreateColloquialWishes < ActiveRecord::Migration
  def change
    create_table :colloquial_wishes do |t|
      t.integer :wish_log_id
      t.integer :wish_by_id
      t.integer :wish_match_id
      t.boolean :status , :default => false
      t.timestamps
    end
  end
end
