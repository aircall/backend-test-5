# == Schema Information
#
# Table name: recordings
#
#  id           :bigint(8)        not null, primary key
#  duration_s   :integer
#  provider_sid :string
#  started_at   :datetime
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  call_id      :bigint(8)
#
# Indexes
#
#  index_recordings_on_call_id  (call_id)
#

class Recording < ApplicationRecord

  belongs_to :call

  def message_available?
    self.url.present?
  end
end
