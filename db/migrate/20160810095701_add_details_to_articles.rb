class AddDetailsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :s_type, :integer, :default => 0 #0咨询 1案例
  end
end
