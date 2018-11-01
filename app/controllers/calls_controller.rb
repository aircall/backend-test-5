class CallsController < ApplicationController
  # Note: Twilio recommends disableling the CSRF token check for their webhook:
  # https://www.twilio.com/blog/2016/05/calling-rails-5-getting-started-with-twilio-on-rails.html#h.fgfyo1vvnaqk
  skip_before_action :verify_authenticity_token, except: [:index]
  before_action :find_call, except: [:index, :call_handler]

  def index
    @calls = Call.order('created_at DESC')
  end

  # Twilio webhook starting point for incoming calls
  # POST /ivr/welcome
  def start
    @call = Call.create(sid: params[:CallSid], from: params[:Caller], status: params[:CallStatus])
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(action: '/ivr/response', method: 'POST') do |gather|
      gather.say(message: 'Thank you for calling Zayne. Please press 1 to reach his primary number. Press 2 to leave a message.', voice: 'Alice')
	  end
    render xml: response.to_s
  end

  # Handles the users response 
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

  # Redirect for forwarded call selection
  # Post '/ivr/forward'
  def forward
    @call.update(action: 'forward', status: params[:CallStatus])
  end

  # Redirect for recording messages selections  
  # Post '/ivr/record'
  def record
    @call.update(action: 'record', status: params[:CallStatus])
  end

  # Redirect after recorded message completed
  # Post '/ivr/after-record'
  def after_record
    @call.update(status: 'completed', recording_url: params[:RecordingUrl], duration: params[:RecordingDuration])
  end
  
  private
    def find_call
      @call = Call.find_by(sid: params[:CallSid])
    end
end
