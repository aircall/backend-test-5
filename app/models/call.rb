class Call < ApplicationRecord
  validates :call_sid, uniqueness: true

  scope :ordered, -> { order(created_at: :asc) }
end
