require 'twilio-ruby'

class TwilioService

  def self.gather
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(action: 'menu', method: 'POST', numDigits: 1) do |gather|
      gather.say(message: 'Thanks for aircalling, press 1 or 2.')
    end
    response.say(message: 'We didn\'t receive any input. Goodbye!')

    response
  end

  def self.say(phrase, exit = false)
    Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: phrase)
      if exit
        r.hangup
      else
        r.redirect('voice')
      end
    end

  end

  def self.dial(phone_number)
    Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(number: phone_number)
    end
  end

  def self.record
    Twilio::TwiML::VoiceResponse.new do |r|
      r.record(timeout: 10)
    end
  end
end