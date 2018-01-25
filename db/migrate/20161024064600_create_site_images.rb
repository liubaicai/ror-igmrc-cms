class CreateSiteImages < ActiveRecord::Migration
  def change
    create_table :site_images do |t|

      t.timestamps null: false
    end

    add_column :site_images, :site_id, :integer
  end
end
