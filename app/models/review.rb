# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :text_review, length: { maximum: 1000, too_long: 'Your review must be under 1000 characters.' }
end
