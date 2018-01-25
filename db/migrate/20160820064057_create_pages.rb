class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content, null:true, :limit => 16777214

      t.timestamps null: false
    end
  end
end
