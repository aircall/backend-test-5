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

  enum choice: { forwarding: 1, voice_recording: 2, other: 3 }

  def voice_message_available?
    self.voice_recording? && self.recording.try(:message_available?)
  end
end
