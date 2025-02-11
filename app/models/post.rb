class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  # post and tages relation
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # vaildation
  validates :title, :body, presence: true
  validates :tags, presence: { message: "must have at least one tag" }
  scope :recent, -> { where("created_at >= ?", 24.hours.ago) }
  
  def tag_names=(names)
    self.tags = names.map do |name|
      Tag.find_or_create_by(name: name.strip.downcase)
    end
  end
end
