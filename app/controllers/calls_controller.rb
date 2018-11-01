class CallsController < ApplicationController
  # Note: Twilio recommends disabling the CSRF token check for their webhook:
  # https://www.twilio.com/blog/2016/05/calling-rails-5-getting-started-with-twilio-on-rails.html#h.fgfyo1vvnaqk
  skip_before_action :verify_authenticity_token, except: [:index]
  before_action :find_call, except: [:index, :start]

  def index
    @calls = Call.order('created_at DESC')
  end

  # Receives data from Twilio when a new call comes in
  # POST '/ivr/start'
  def start
    @call = Call.create(sid: params[:CallSid], from: params[:Caller], status: params[:CallStatus])
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(action: '/ivr/response', method: 'POST') do |gather|
      gather.say(message: 'Thank you for calling Zayne. Please press 1 to reach his primary number. Press 2 to leave a message.', voice: 'Alice')
    end
    render xml: response.to_s
  end

  # Handles the users selected choice
  # POST '/ivr/response'
  def user_response
    user_selection = params[:Digits]
    response = Twilio::TwiML::VoiceResponse.new
    case user_selection
    when '1'
      response.say(message: 'Thank you. You selected 1. We will connect you to Zayne\'s direct line now. One moment please.', voice: 'Alice')
      response.dial(number: ENV['PHONE_NUMBER'], action: '/ivr/forward', method: 'POST')
    when '2'
      response.say(message: 'Thank you. You selected 2. Please leave a message after the beep.', voice: 'Alice')
      response.record(timeout: 10, transcribe: true, action: '/ivr/record', method: 'POST', recordingStatusCallback: '/ivr/after-record')
    else
      response.say(message: 'Unfortunately, it appears you have selected an invalid option. Please call back and try again.', voice: 'Alice')
    end
    render xml: response.to_s
  end

  # Updates call record when user has selected forwarding (option 1)
  # POST '/ivr/forward'
  def forward
    @call.update(action: 'forward', status: params[:CallStatus])
  end

  # Updates call record when user has selected to leave a message (option 2)
  # POST '/ivr/record'
  def record
    @call.update(action: 'record', status: params[:CallStatus])
  end

  # Updates call record after a message has been recorded
  # POST '/ivr/after-record'
  def after_record
    @call.update(status: 'completed', recording_url: params[:RecordingUrl], duration: params[:RecordingDuration])
  end
  
  # Receives data from Twilio when call status changes
  # POST '/ivr/call-status-change'
  def call_status_change
    @call.update(status: params[:CallStatus], duration: params[:CallDuration])
  end

  private
    def find_call
      @call = Call.find_by(sid: params[:CallSid])
    end
end
