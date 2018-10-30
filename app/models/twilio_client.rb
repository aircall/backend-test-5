class TwilioClient
  CALL_RESPONSES = {
    no_input_end_call: 'Sorry, we did not receive any input, this phone call will now end.'.freeze,
    welcome_message: 'Hi, and thank you for calling Aircall.  Please press 1 to speak with Jeff or 2 to leave a voicemail.'.freeze,
    no_input_redirect_to_main_menu: 'Sorry, we did not receive a valid input, you will now be taken back to the main menu.'.freeze
  }.freeze
  PERSONAL_NUMBER = Rails.application.secrets.personal_number

  class << self
    def call(phone_number)
      ::Twilio::TwiML::VoiceResponse.new do |response|
        response.dial(number: phone_number)
      end
    end

    def record_voicemail
      ::Twilio::TwiML::VoiceResponse.new do |response|
        response.record(timeout: 7)
      end
    end

    def welcome_and_provide_options
      response = ::Twilio::TwiML::VoiceResponse.new
      response.gather(action: 'handle_input', method: 'POST', numDigits: 1) do |gather|
        gather.say(message: CALL_RESPONSES.fetch(:welcome_message))
      end
      response
    end

    def handle_invalid_key_press
      ::Twilio::TwiML::VoiceResponse.new do |response|
        response.say(message: CALL_RESPONSES.fetch(:no_input_redirect_to_main_menu))
        response.redirect('handle_invalid_input', method: 'GET')
      end
    end
  end
end
