require 'twilio-ruby'

class CallsController < ApplicationController
  # to get around using a POST callback and Rails "Can't verify CSRF token authenticity"
  skip_before_action  :verify_authenticity_token

  TO_PARAM = 'To'.freeze
  FROM_PARAM = 'From'.freeze
  SID_PARAM = 'CallSid'.freeze
  STATUS_PARAM = 'CallStatus'.freeze
  DURATION_PARAM = 'CallDuration'.freeze
  DIGITS_PARAM = 'Digits'.freeze
  RECORDING_URL_PARAM = 'RecordingUrl'.freeze

  COMPLETED_STATUS = 'completed'.freeze

  MENU_OPTIONS = 'To redirect the call, press 1. To leave a voicemail, press 2.'
  FORWARDING_NUMBER = '+15556667777'
  VOICEMAIL_KEY = '#'
  VOICEMAIL_LENGTH = '30'
  VOICEMAIL_PATH = '/calls/voicemail_handler'

  def index
    # brute force approach - pagination and other niceties would come in a production environment
    @calls = Call.all
  end

  def incoming
    # in production code, we'd want to validate the Twilio calls per their documentation

    # if we haven't saved the call yet, save it
    unless Call.exists?(sid: params[SID_PARAM])
      call_info = {
        to: params[TO_PARAM],
        from: params[FROM_PARAM],
        sid: params[SID_PARAM],
        status: params[STATUS_PARAM]
      }
      Call.new(call_info).save
    end

    response = if params[DIGITS_PARAM]
      case params[DIGITS_PARAM]
        when '1' # handle call forwarding
          Twilio::TwiML::VoiceResponse.new do |r|
            r.say('Forwarding your call now .')
            r.dial number: FORWARDING_NUMBER
          end
        when '2' # handle voicemail
          Twilio::TwiML::VoiceResponse.new do |r|
            r.say("Please leave a message and press #{VOICEMAIL_KEY} or hang up when finished.")
            r.record(finishOnKey: VOICEMAIL_KEY, maxLength: VOICEMAIL_LENGTH, action: VOICEMAIL_PATH)
            r.say('I did not receive a recording.')
          end
        else # another key was pressed
          Twilio::TwiML::VoiceResponse.new do |r|
            r.say('Sorry, I don\'t understand that choice.')
            r.pause
            r.gather(numDigits: 1) do |g|
              g.say(MENU_OPTIONS)
            end
            r.redirect(request.env['PATH_INFO'])
          end
      end
    else # the initial call (no digits have been pressed yet)
      Twilio::TwiML::VoiceResponse.new do |r|
        r.gather(numDigits: 1) do |g|
          g.say(MENU_OPTIONS)
        end
        r.redirect(request.env['PATH_INFO'])
      end
    end

    render xml: response.to_xml
  end

  # update the call record as the Twilio status changes
  def status_handler
    call = Call.find_by sid: params[SID_PARAM]
    if call
      call.status = params[STATUS_PARAM]
      if call.status == COMPLETED_STATUS
        call.duration = params[DURATION_PARAM]
      end
      call.save
    end

    head :ok
  end

  # update the call record when a voicemail has been left
  def voicemail_handler
    call = Call.find_by sid: params[SID_PARAM]
    if call
      call.voicemail = params[RECORDING_URL_PARAM]
      call.save
    end

    render status: :ok, plain: 'Thank you.'
  end
end
