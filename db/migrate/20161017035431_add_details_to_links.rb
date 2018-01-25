class AddDetailsToLinks < ActiveRecord::Migration
  def change
    add_column :links, :sort, :integer, :default => 0
  end
end
