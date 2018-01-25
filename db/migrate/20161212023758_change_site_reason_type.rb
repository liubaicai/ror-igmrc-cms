class ChangeSiteReasonType < ActiveRecord::Migration
  def change
    change_column :sites_logs, :reason, :text, :limit => 65535, :null => true
    change_column :sites, :reason, :text, :limit => 65535, :null => true
  end
end
