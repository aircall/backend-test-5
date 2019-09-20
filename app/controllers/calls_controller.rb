class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def ivr
    twiml_response = Twilio::TwiML::VoiceResponse.new
    @call = Call.create(caller: params['From'], status: 'Active')

    twiml_gather = Twilio::TwiML::Gather.new(num_digits: '1', action: "https://backend-test-5.herokuapp.com/calls/#{@call.id}/ivr_menu_select")
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
        twiml_response.dial(number: '7325168130', action: "https://backend-test-5.herokuapp.com/calls/#{@call.id}/forward")
      when '2'
        twiml_response.record(play_beep: 'true', max_length: '60', action: "https://backend-test-5.herokuapp.com/calls/#{@call.id}/create_voicemail")
      else
        twiml_response.hangup
        @call.update(status: 'Over', duration: 0)
    end

    render xml: twiml_response.to_s
  end

  def create_voicemail
    @call = Call.find(params[:call_id])
    @call.update(voicemail_url: params[:RecordingUrl], status: 'Over', duration: params['RecordingDuration'])
    # default no content response
  end

  def forward
    @call = Call.find(params[:call_id])
    @call.update(status: 'Over', duration: params['DialCallDuration'])
    # default no content response
  end

end
