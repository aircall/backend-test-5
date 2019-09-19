class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def ivr
    twiml_response = Twilio::TwiML::VoiceResponse.new
    @call = Call.create(caller: params['From'], status: 'Active')

    twiml_gather = Twilio::TwiML::Gather.new(num_digits: '1', action: "https://backend-test-5.herokuapp.com/calls/:#{@call.id}/ivr_menu_select")
    twiml_gather.say(message: "Press 1 to redirect call or press 2 to leave a voicemail", voice: 'alice', loop: 3)
    twiml_response.append(twiml_gather)

    render xml: twiml_response.to_s
  end

  def ivr_menu_select
    selected_digit = params[:Digits]
    @call          = Call.find(params[:call_id])
    twiml_response = Twilio::TwiML::VoiceResponse.new

    case selected_digit
      when '1'
        twiml_response.dial(number: '7325168130')
      when '2'
        twiml_response.record(play_beep: 'true', max_length: '60', action: "https://backend-test-5.herokuapp.com/calls/:#{@call.id}/create_voicemail")
      else
        twiml_response.hangup
    end

    render xml: twiml_response.to_s
  end

  def create_voicemail
    voicemail_url = params[:RecordingUrl]
    @call         = Call.find(params[:call_id])

    # default no content response
  end

end
