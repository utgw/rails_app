class User < ApplicationRecord
    has_secure_password

    validates :username, {presence: true}
    validates :email, {presence: true, uniqueness: true}
    validates :password, {presence: true}

    has_many :posts
    has_many :likes
    has_many :liked_posts, through: :likes, source: :post
    has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
    has_many :followings, through: :active_relationships, source: :follower
    has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
    has_many :followers, through: :passive_relationships, source: :following

    def followed_by?(user)
        passive_relationships.find_by(following_id: user.id).present?
    end
end
