class CallChannel < ApplicationCable::Channel
  def subscribed
    stream_from "call_channel"
  end
end
