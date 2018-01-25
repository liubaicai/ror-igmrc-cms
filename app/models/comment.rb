class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :site
  belongs_to :user
  self.per_page = 15
end
