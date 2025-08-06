class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # Model associations
  has_many :todos, foreign_key: :created_by, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
