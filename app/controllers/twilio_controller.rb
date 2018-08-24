require 'twilio-ruby'


class TwilioController < ApplicationController

  PHONE_NUMBER_TO_CALL = '+17736491909'
  PARAM_TO = 'To'.freeze
  PARAM_FROM = 'From'.freeze
  PARAM_SID = 'CallSid'.freeze
  PARAM_STATUS = 'CallStatus'.freeze
  PARAM_DURATION = 'RecordingDuration'.freeze
  PARAM_RECORDING_URL = 'RecordingUrl'.freeze
  COMPLETED_STATUS = 'completed'.freeze

  skip_before_action :verify_authenticity_token

  def voice
    unless Call.exists?(sid: params[PARAM_SID])
      call_info = {
          to: params[PARAM_TO],
          from: params[PARAM_FROM],
          sid: params[PARAM_SID],
          status: params[PARAM_STATUS]
      }
      Call.new(call_info).save

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
          response = twiml_dial(PHONE_NUMBER_TO_CALL)
        when "2"
          response = twiml_record
        else
          response = twiml_say("Returning to the main menu.")
      end

      update_call(params[PARAM_SID], params[PARAM_STATUS],
                  params[PARAM_DURATION], params[PARAM_RECORDING_URL])
      render xml: response.to_s
    end

    private
    def twiml_say(phrase, exit = false)
      Twilio::TwiML::VoiceResponse.new do |r|
        r.say(message: phrase)
        if exit
          r.hangup
        else
          r.redirect('voice')
        end
      end

    end

    private
    def twiml_dial(phone_number)
      Twilio::TwiML::VoiceResponse.new do |r|
        r.dial(number: phone_number)
      end
    end

    private
    def twiml_record
      Twilio::TwiML::VoiceResponse.new do |r|
        r.record(timeout: 10)
      end
    end

    private
    def update_call(sid, new_status, duration, recording_url)
      call = Call.find_by sid: sid
      if call
        call.status = new_status
        call.duration = duration
        call.voicemail = recording_url

        call.save
      end
    end

  end
end
