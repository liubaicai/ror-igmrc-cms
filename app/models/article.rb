class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping dynamic: false do
    indexes :title
    indexes :content
  end

  def as_indexed_json(options={})
    self.as_json(
        except: [:article_type_id,:user_id],
        include: { article_type: { only: [:id,:title]},
                   user: { only: [:id,:nickname]}}
    )
  end

  belongs_to :user
  belongs_to :article_type
  has_many :comments
  self.per_page = 10

  def self.create(attributes = nil, &block)
    if attributes.is_a?(Array)
      attributes.collect { |attr| create(attr, &block) }
    else
      object = new(attributes, &block)
      object.alias_url = object.title.gsub(/\p{P}/,'-')
      object.save
      object
    end
  end
end
