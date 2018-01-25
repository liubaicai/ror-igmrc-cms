class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null:false
      t.text :content, null:false, :limit => 16777214
      t.boolean :is_valid, :default => true

      t.timestamps null: false
    end

    # add_reference :articles, :users, index: true, foreign_key: true
    # add_reference :articles, :article_types, index: true, foreign_key: true
    add_column :articles, :user_id, :integer
    add_column :articles, :article_type_id, :integer
  end
end
