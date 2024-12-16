# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :bulletins, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true
end
