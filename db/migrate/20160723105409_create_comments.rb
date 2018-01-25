class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content, null:false
      t.string :admin_comment, :default => ''
      t.boolean :is_valid, :default => false

      t.timestamps null: false
    end

    # add_reference :comments, :articles, index: true, foreign_key: true
    # add_reference :comments, :users, index: true, foreign_key: true
    add_column :comments, :article_id, :integer
    add_column :comments, :site_id, :integer
    add_column :comments, :user_id, :integer
  end
end
