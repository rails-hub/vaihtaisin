class AddSequenceToLocationWishes < ActiveRecord::Migration
  def change
    add_column :locations_wishes, :sequence_id, :integer
  end
end
