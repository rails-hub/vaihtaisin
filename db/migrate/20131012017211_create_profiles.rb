class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.boolean :email_contact
      t.timestamps
    end
  end
end
