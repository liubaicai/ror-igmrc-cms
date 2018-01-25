class AddAliasToPages < ActiveRecord::Migration
  def change
    add_column :pages, :alias_url, :string, :default => ''
  end
end
