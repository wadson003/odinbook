class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :sent_friendships, class_name: "Friendship", foreign_key: :sender_id, dependent: :destroy
  has_many :received_friendships, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy
  
  after_create :send_welcome_email

  def friends
    friends_sent = sent_friendships.where(status: "accepted").pluck(:receiver_id)
    friends_received = received_friendships.where(status: "accepted").pluck(:sender_id)
    User.where(id: friends_sent + friends_received)
  end

  def pending_requests
    received_friendships.where(status: "pending")
  end

  def sent_requests
    sent_friendships.where(status: "pending")
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  private
  def send_welcome_email
     UserMailer.welcome_email(self).deliver_later
  end
end
