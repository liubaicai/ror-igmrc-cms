class AddAliasToArticleTypes < ActiveRecord::Migration
  def change
    add_column :article_types, :alias_url, :string, :default => ''
  end
end
