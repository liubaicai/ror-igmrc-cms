class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping dynamic: false do
    indexes :username
    indexes :nickname
    indexes :phone
  end

  def as_indexed_json(options={})
    self.as_json(
        # except: [:article_type_id,:user_id],
        # include: { article_type: { only: [:id,:title]},
        #            user: { only: [:id,:nickname]}}
    )
  end

  has_secure_password
  belongs_to :permission
  has_many :articles
  has_many :comments
  has_many :messages
  has_many :sites_logs
  self.per_page = 20

end
