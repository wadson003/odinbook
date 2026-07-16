class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true
end
