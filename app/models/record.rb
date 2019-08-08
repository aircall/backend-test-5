# frozen_string_literal: true

class Record < ApplicationRecord
  validates :link, :duration, :sid, presence: true
  belongs_to :call
end
