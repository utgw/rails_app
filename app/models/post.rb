class Post < ApplicationRecord
  validates :content, { presence: true, length: { maximum: 140 } }
  validates :user_id, { presence: true }

  has_many :likes, dependent: :destroy

  belongs_to :user

  scope :find_posts, lambda { |user, page|
                       where(user_id: [user.id, *user.followings]).order(created_at: :desc).page(page).per(10)
                     }
end
