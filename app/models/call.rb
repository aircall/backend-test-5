# == Schema Information
#
# Table name: calls
#
#  id           :bigint(8)        not null, primary key
#  choice       :integer
#  country      :string
#  duration_s   :integer
#  end_at       :datetime
#  phone_number :string
#  provider_sid :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Call < ApplicationRecord
  has_one :recording

  def voice_message_available?
    self.recording && self.recording.url
  end
end
