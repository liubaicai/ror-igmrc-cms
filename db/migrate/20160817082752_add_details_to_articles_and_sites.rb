class AddDetailsToArticlesAndSites < ActiveRecord::Migration
  def change
    add_column :articles, :alias_url, :string, :default => ''
    add_column :sites, :alias_url, :string, :default => ''
  end
end
