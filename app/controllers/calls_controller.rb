class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def ivr
    twiml_response = Twilio::TwiML::VoiceResponse.new

    twiml_gather = Twilio::TwiML::Gather.new(num_digits: '1', action: 'https://backend-test-5.herokuapp.com/calls/ivr_menu_select')
    twiml_gather.say("Press 1 to redirect call or press 2 to leave a voicemail", voice: 'alice', loop: 3)
    twiml_response.append(twiml_gather)

    render xml: twiml_response.to_s
  end

  def ivr_menu_select
    selected_digit = params[:Digits]
    twiml_response = Twilio::TwiML::VoiceResponse.new

    case selected_digit
      when '1'
        twiml_response.dial(number: '+33123456789')
      when '2'
        # leave voicemail
      else
    end

    render xml: twiml_response.to_s
  end

end
