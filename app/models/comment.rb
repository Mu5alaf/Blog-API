class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  # vaildation
  validates :body, presence: true
end
