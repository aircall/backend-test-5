# frozen_string_literal: true
class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_call, only: [:call, :update]

  def index
    @calls = Call.all
  end

  def call
    if @call
      @call.update(status: params['CallStatus'])
      stream(@call, 'update')
    else
      @call = Call.create!(call_params)
      stream(@call, 'create')
    end

    render xml: TwilioService.new.call(params['Digits'])
  end

  def update
    @call.update(call_params)
    stream(@call, 'update')

    render xml: Twilio::TwiML::VoiceResponse.new
  end

  private

  def find_call
    @call = Call.find_by(call_sid: params['CallSid'])
  end

  def call_params
    {
     call_sid: params['CallSid'],
     direction: params['Direction'],
     number: params['From'],
     url: params['RecordingUrl'],
     status: params['DialCallStatus'] || params['CallStatus'],
     duration: params['DialCallDuration'] || params['RecordingDuration'],
    }
  end

  def stream(content, action)
    ActionCable.server.broadcast 'call_channel',
                                  content: content,
                                  action: action
  end

end
