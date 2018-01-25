class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null:false
      t.string :password_digest, null:false
      t.string :phone, null:false
      t.string :token, :default => ''

      t.string :nickname, :default => ""
      t.string :email, :default => ''
      t.string :description, :default => ''
      t.integer :sex, :default => 0 #0未指定 1男性 2女性
      t.string :avatar, :default => ''
      t.boolean :is_valid, :default => true

      t.timestamps null: false
    end

    # add_reference :users, :permissions, index: true, foreign_key: true
    add_column :users, :permission_id, :integer
  end
end
