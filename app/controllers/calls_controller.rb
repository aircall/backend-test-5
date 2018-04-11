require 'twilio-ruby'

class CallsController < ApplicationController
  # to get around using a POST callback and Rails "Can't verify CSRF token authenticity"
  skip_before_action  :verify_authenticity_token

  TO_PARAM = 'To'.freeze
  FROM_PARAM = 'From'.freeze
  SID_PARAM = 'CallSid'.freeze
  STATUS_PARAM = 'CallStatus'.freeze
  DURATION_PARAM = 'Duration'.freeze

  COMPLETED_STATUS = 'completed'.freeze

  def test
    # Get your Account Sid and Auth Token from twilio.com/console
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    puts "#{account_sid} #{auth_token}"

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token
    puts @client.inspect

    call = @client.calls.create(
      to: "+19174283671",
      from: "+12015716491",
      url: "http://demo.twilio.com/docs/voice.xml")
    puts call.to

    render plain: "Call made"
  end

  def incoming
    call_info = {
      to: params[TO_PARAM],
      from: params[FROM_PARAM],
      sid: params[SID_PARAM],
      status: params[STATUS_PARAM]
    }
    Call.new(call_info).save

    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say("You have reached the Tyrell Corporation. More human than human.")
    end
    render xml: response.to_xml
  end

  def status
    call = Call.find_by sid: params[SID_PARAM]
    call.status = params[STATUS_PARAM]
    if call.status == COMPLETED_STATUS
      call.duration = params[DURATION_PARAM]
    end
    call.save

    head :ok
  end
end
