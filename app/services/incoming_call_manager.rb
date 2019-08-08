class IncomingCallManager
  require 'twilio-ruby'
  # Twilio REST API is used
  # link to the documentation : https://www.twilio.com/docs

  def initialize(params, path_params)
    @params = params
    @resp = Twilio::TwiML::VoiceResponse.new
    @process_selected_choice_path = path_params[:process_selected_choice_path]
    @give_choice_path = path_params[:give_choice_path]
    @voice_mail_redirection_path = path_params[:voice_mail_redirection_path]
    @phone_redirection_path = path_params[:phone_redirection_path]
  end

  # Gather user input via Keypad.
  # If the timeout is reached Twilio will move onto the next verb.
  def give_choice
    @resp.gather(num_digits: 1, timeout: 4, action: @process_selected_choice_path) do |gather|
      gather.say(message: 'If you want to be forwarded, press 1. If you prefer to leave a message, press 2.', voice: 'alice')
    end
    @resp.redirect(@give_choice_path)
  end

  # If the caller presses 1, call is forwarded to another phone number.
  # If he presses 2, he is able to leave a voicemail.
  def process_selected_choice
    case @params[:Digits]
    when '1'
      phone_redirection
    when '2'
      voice_mail_redirection
    else
      @resp.say(message: 'Sorry, I don\'t understand that choice.', voice: 'alice')
      @resp.pause
      give_choice
    end
  end

  # dial will only dial a new party from an active, ongoing call
  def phone_redirection
    # '12345' will be spoken as "twelve thousand three hundred forty-five." 
    # Whereas '1 2 3 4 5' will be spoken as "one two three four five".
    @resp.say(message: "You are redirected to #{ENV['FORWARDING_NUMBER'].gsub(/(.{1})/, '\1 ')}.")
    @resp.dial(action: @phone_redirection_path, number: ENV['FORWARDING_NUMBER'])
  end

  def end_phone_call
    @resp.say(message: 'Thank you for your call, Goodbye')
  end

  def voice_mail_redirection
		@resp.say(message: 'Please leave a message at the beep. Press the star key when finished.')
    @resp.record(action: @voice_mail_redirection_path, max_length: 60, finish_on_key: '#')
  end

  def end_voice_mail
    @resp.say(message: 'Thank you for your message.')
    @resp.hangup
  end
end
