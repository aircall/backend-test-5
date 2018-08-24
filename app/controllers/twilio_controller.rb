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
    CallService.create(params[PARAM_SID], params[PARAM_TO], params[PARAM_FROM], params[PARAM_STATUS])
    render xml: TwilioService.gather.to_s
  end


  def menu
    user_selection = params[:Digits]

    case user_selection
      when "1"
        response = TwilioService.dial(PHONE_NUMBER_TO_CALL)
      when "2"
        response = TwilioService.record
      else
        response = TwilioService.say("Returning to the main menu.")
    end

    CallService.update(params[PARAM_SID], params[PARAM_STATUS],
                        params[PARAM_DURATION], params[PARAM_RECORDING_URL])
    render xml: response.to_s
  end

end
