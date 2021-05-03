class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  attachment :profile_image, destroy: false
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :follower, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id
  has_many :followed, through: :passive_relationships, source: :follower


  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50 }

  def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end
end
