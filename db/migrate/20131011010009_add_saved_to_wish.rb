class AddSavedToWish < ActiveRecord::Migration
  def change
    add_column :wishes, :saved, :boolean, :default => false
    add_index :wishes, :saved
  end
end
