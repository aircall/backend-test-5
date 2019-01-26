require 'twilio-ruby'
#require 'sanitize'

class CallsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:incoming, :sorting, :recording]

  def incoming
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(num_digits: '1', action: sorting_calls_path)
    gather.say(message: "Welcome on OzoneCall. Press 1 to Call Julien. Press 2 to leave a message. Thank you.", loop: 2)
    response.append(gather)

    render xml: response.to_s
  end

  def sorting
    response = Twilio::TwiML::VoiceResponse.new
    case params[:Digits].to_i
    when 1
      response.dial(number: ENV['REDIRECT_PHONE_NUMBER'])
      response.say(message: 'You are redirect. Good bye')
    when 2
      response.say(message: 'Please leave a message')
      response.record(  timeout: 30,
                        action: recording_calls_path,
                        maxLength: 30,
                        recordingStatusCallback: recording_calls_path)
    else
      response.redirect(incoming_calls_path)
    end

    render xml: response.to_s
  end

  def recording
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: 'Thank you for your message. Good bye')
    render xml: response.to_s
  end

  def transcribe
    response = Twilio::TwiML::VoiceResponse.new
    render xml: response.to_s
  end

  def home
    render plain: "test"
  end
end
