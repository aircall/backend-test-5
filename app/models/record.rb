# frozen_string_literal: true

# Record model
# a call has one record
# a record belongs_to one record
class Record < ApplicationRecord
  validates :link, :duration, :sid, presence: true
  belongs_to :call
end
