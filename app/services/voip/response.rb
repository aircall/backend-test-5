# The VOIP part of this application is currently delegated to Twilio services
# If you want to change, you just have to update the services in the app/services/voip folder
require 'twilio-ruby'

module VOIP
  class Response

    def initialize
      @response = Twilio::TwiML::VoiceResponse.new
    end

    # The current provider is Twilio
    def provider_response
      @response
    end

    # Collect digit input during phone call
    def gather_digit(callback_path, message)
      gather = Twilio::TwiML::Gather.new(num_digits: '1', action: callback_path)
      gather.say(message: message, loop: 1)
      @response.append(gather)
    end
    private :gather_digit

    def gather_digit!(callback_path, message)
      gather_digit(callback_path, message)
      self
    end

    def forward_to_phone_number(phone_number, message = nil)
      @response.dial(number: phone_number)
      @response = @response.say(message: message)
    end

    def forward_to_me(message = nil)
      forward_to_phone_number(ENV['REDIRECT_PHONE_NUMBER'], message)
    end

    # Play a message to the caller
    def say(message)
      @response = @response.say(message: message)
    end
    private :say

    def say!(message)
      say(message)
      self
    end

    # Record the caller voice message
    def record(recording_callback, timeout = 30, max_length = 30)
      @response = @response.record(timeout: timeout, action: recording_callback, maxLength: max_length)
    end
    private :record

    def record!(recording_callback, timeout = 30, max_length = 30)
      record(recording_callback, timeout, max_length)
      self
    end

    # Redirect the caller to another action
    def redirect_to(path)
      @response.redirect(path)
    end

    def to_xml(params = nil)
      @response.to_s
    end

    def to_s
      @response.to_s
    end

  end
end