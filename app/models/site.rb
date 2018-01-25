class Site < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping dynamic: false do
    indexes :title
    indexes :url
    indexes :reason
    indexes :short_reason
    indexes :note
  end

  def as_indexed_json(options={})
    self.as_json(
        except: [:site_type_id],
        include: { site_type: { only: [:id,:title]}}
    )
  end

  belongs_to :site_type
  has_many :site_images
  self.per_page = 10

end
