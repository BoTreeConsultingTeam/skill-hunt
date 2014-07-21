class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender, limit: 1
      t.string :email
      t.string :password
      t.boolean :blocked, default: false
      t.integer :country_id, null: false
      t.timestamps
    end
  end
end
