class User < ApplicationRecord
  has_secure_password

  validates :username, presence: { message: 'ユーザー名は必須項目です' }
  validates :email, presence: { message: 'メールアドレスは必須項目です' }
  validates :email, uniqueness: { message: 'このメールアドレスはすでに登録済みです' }
  validates :password, presence: { message: 'パスワードは必須項目です' }

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :active_relationships, class_name: 'Relationship', foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  def find_posts(page)
    posts.includes(:likes).order(created_at: :desc).page(page).per(10)
  end

  def find_liked_posts(page)
    liked_posts.includes(%i[user likes]).order('likes.created_at DESC').page(page).per(10)
  end

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
end
