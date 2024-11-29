class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :topic, presence: true
  validates :content, presence: true
end

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
end


class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
end

