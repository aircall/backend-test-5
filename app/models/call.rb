# frozen_string_literal: true

# Call model
# default value for forwarding is 0
# If the caller selects a digit the forwarding value is updated
class Call < ApplicationRecord
  validates :from, :direction, :called, :sid, :status, presence: true
  has_one :record
end
