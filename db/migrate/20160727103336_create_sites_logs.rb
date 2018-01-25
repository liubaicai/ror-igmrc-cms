class CreateSitesLogs < ActiveRecord::Migration
  def change
    create_table :sites_logs do |t|
      t.string :url, null:false #url地址
      t.string :title, :default => '' #网站标题
      # t.integer :type, :default => 0  #类型,0全部,1传销,2赌博,3诈骗
      t.string :reason, :limit => 65535  #举报理由
      t.string :short_reason, :default => ''  #简短举报理由
      t.integer :count, :default => 0 #举报数量
      t.string :images, :default => ''  #图片证据
      t.string :note, :default => ''  #备注,如:"危险性高"
      t.boolean :is_valid, :default => false #举报是否有效

      t.timestamps null: false
    end

    # add_reference :sites, :site_types, index: true, foreign_key: true
    add_column :sites_logs, :site_type_id, :integer
    add_column :sites_logs, :user_id, :integer
  end
end
