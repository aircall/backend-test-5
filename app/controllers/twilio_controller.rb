require 'twilio-ruby'


class TwilioController < ApplicationController

  PHONE_NUMBER_TO_CALL = '+17736491909'
  skip_before_action :verify_authenticity_token

  def voice
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(action: 'menu', method: 'POST', numDigits: 1) do |gather|
      gather.say(message: 'Thanks for aircalling, press 1 or 2.')
    end
    response.say(message: 'We didn\'t receive any input. Goodbye!')

    render xml: response.to_s
  end


  def menu
    user_selection = params[:Digits]

    case user_selection
      when "1"
        twiml_dial(PHONE_NUMBER_TO_CALL)
      when "2"
        twiml_record
      else
        @output = "Returning to the main menu."
        twiml_say(@output)
    end
  end

  def twiml_say(phrase, exit = false)
    # Respond with some TwiML and say something.
    # Should we hangup or go back to the main menu?
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message:phrase)
      if exit
        r.hangup
      else
        r.redirect('voice')
      end
    end

    render xml: response.to_s
  end

  def twiml_dial(phone_number)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(number: phone_number)
    end

    render xml: response.to_s
  end

  def twiml_record
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.record(timeout: 10)
    end

    render xml: response.to_s
  end
end
