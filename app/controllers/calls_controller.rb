require 'twilio-ruby'
#require 'sanitize'

class CallsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:incoming, :sorting]

  def incoming
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(num_digits: '1', action: sorting_calls_path)
    gather.say(message: "Welcome on OzoneCall. Press 1 to Call Julien. Press 2 to leave a message. Thank you.", loop: 2)
    response.append(gather)

    render xml: response.to_s
  end

  def sorting
    user_selection = params[:Digits]

    case user_selection
    when 1
      response = Twilio::TwiML::VoiceResponse.new
      response.dial(number: ENV['REDIRECT_PHONE_NUMBER'])
      response.say(message: 'You are redirect. Good bye')
      render xml: response.to_s
    when 2
      twiml_say("you pressed #{user_selection}")
    end
  end

  def home
    render plain: "test"
  end

  def twiml_say(phrase, exit = false)
    # Respond with some TwiML and say something.
    # Should we hangup or go back to the main menu?
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: phrase, voice: 'alice', language: 'en-GB')
      if exit
        r.say(message: "Thank you for calling OzoneCall.")
        r.hangup
      else
        r.redirect(incoming_calls_path)
      end
    end

    render xml: response.to_s
  end
end
