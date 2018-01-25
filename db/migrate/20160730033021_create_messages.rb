class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content, null:false
      t.boolean :isread, :default => false
      t.integer :sender, null:false

      t.timestamps null: false
    end

    add_column :messages, :user_id, :integer
  end
end
