class Post < ApplicationRecord
    validates :content, {presence: true, length: {maximum: 140}}
    validates :user_id, {presence: true}

    has_many :likes, dependent: :destroy

    belongs_to :user
end
  