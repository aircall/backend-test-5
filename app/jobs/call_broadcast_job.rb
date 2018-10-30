# Normally, I would probably have all broadcasts run in a job, but I am not sure
# how synchronous we want the updates to be.
class CallBroadcastJob < ApplicationJob
  queue_as :default

  def perform(call)
    ActionCable.server.broadcast 'call_channel', id: call.id, call: render_message(call)
  end

  def render_message(call)
    ApplicationController.renderer.render(partial: 'calls/call', locals: { call: call })
  end
end
