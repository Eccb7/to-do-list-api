class Todo < ApplicationRecord
  # Model associations
  belongs_to :user, foreign_key: :created_by

  # Validations
  validates :title, presence: true
  validates :created_by, presence: true

  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :by_priority, -> { order(:priority) }

  # Default values
  before_save :set_default_completed
  before_save :set_default_priority

  private

  def set_default_completed
    self.completed ||= false
  end

  def set_default_priority
    self.priority ||= 1
  end
end
