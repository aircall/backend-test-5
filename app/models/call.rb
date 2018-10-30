class Call < ApplicationRecord
  alias_attribute :CallSid, :call_sid
  alias_attribute :Caller, :caller
  alias_attribute :CallDuration, :call_duration
  alias_attribute :RecordingUrl, :recording_url
  alias_attribute :CallStatus, :call_status
  alias_attribute :From, :from
  alias_attribute :To, :to

  after_create :broadcast_call_data
  after_update :broadcast_call_data

  def broadcast_call_data
    ActionCable.server.broadcast 'call_channel', id: id, call: render_message
  end

  def render_message
    CallsController.render(partial: 'calls/call', locals: { call: self })
  end
end
