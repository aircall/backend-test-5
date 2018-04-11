require 'twilio-ruby'

class CallsController < ApplicationController
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
    puts "!!! INCOMING CALL !!!"
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say("You have reached the Tyrell Corporation. More human than human.")
    end
    render xml: response.to_xml
  end
end
