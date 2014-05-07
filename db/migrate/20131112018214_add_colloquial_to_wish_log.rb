class AddColloquialToWishLog < ActiveRecord::Migration
  def change
    add_column :wish_logs, :colloquial, :boolean, :default => false
    #add_column :wish_logs, :colloquial_wish_id, :integer
  end
end
