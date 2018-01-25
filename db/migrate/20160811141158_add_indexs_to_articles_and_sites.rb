class AddIndexsToArticlesAndSites < ActiveRecord::Migration
  def change
    add_index :articles, :title
    add_index :articles, :content, length: 255
    add_index :sites, :title
    add_index :sites, :url
    add_index :sites, :reason
    add_index :sites, :short_reason
  end
end
