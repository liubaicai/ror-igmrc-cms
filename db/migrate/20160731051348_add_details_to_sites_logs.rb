class AddDetailsToSitesLogs < ActiveRecord::Migration
  def change
    add_column :sites_logs, :email, :string
    add_column :sites_logs, :phone, :string
  end
end
