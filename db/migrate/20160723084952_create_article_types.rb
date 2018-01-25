class CreateArticleTypes < ActiveRecord::Migration
  def change
    create_table :article_types do |t|
      t.string :title, null:false

      t.timestamps null: false
    end
  end
end
