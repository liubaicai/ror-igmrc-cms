class Message < ActiveRecord::Base
  belongs_to :user
  self.per_page = 15
end
