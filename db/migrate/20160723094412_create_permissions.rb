class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :title, null:false
      t.integer :level, :default => 0

      t.timestamps null: false
    end
  end
end
