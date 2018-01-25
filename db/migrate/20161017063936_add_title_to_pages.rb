class AddTitleToPages < ActiveRecord::Migration
  def change
    add_column :pages, :title, :string, :default => ''
  end
end
