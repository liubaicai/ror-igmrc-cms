class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url, null:false #url地址
      t.string :title, :default => '' #网站标题

      t.timestamps null: false
    end
  end
end
