class AddStatusToWishes < ActiveRecord::Migration
  def change
    add_column :wishes, :status, :string, :default => "ACTIVE"
  end
end
