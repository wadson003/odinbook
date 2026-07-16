class Friendship < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :status, inclusion: { in: %w[pending accepted declined] }
  validates :sender_id, uniqueness: { scope: :receiver_id, message: "Demande deja existante" }
end
