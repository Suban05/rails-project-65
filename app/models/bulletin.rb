# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true, length: { minimum: 2, maximum: 50 }
  validates :description, presence: true, length: { minimum: 2, maximum: 1000 }

  scope :published_or_created_by, ->(user) { published.or(Bulletin.where(user_id: user.id)) }

  aasm column: :state do
    state :draft, initial: true
    state :under_moderation, :published, :rejected, :archived

    event :to_moderate do
      transitions from: :draft, to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end
  end

  def may_be_edited?
    draft? || rejected?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title state category_id]
  end
end
