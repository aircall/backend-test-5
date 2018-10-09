# frozen_string_literal: true
class TwilioService

  MENU = 'Press 1 if you wanna talk to Gabriel. Press 2 if you want to leave a voicemail for Gabriel.'
  INVALID_INPUT = 'Sorry, I don\'t understand that choice.'
  CELL = Rails.application.credentials.cell

  attr_reader :res

  def initialize
    @res = Twilio::TwiML::VoiceResponse.new
  end

  def call(user_input)
    user_input ? menu(user_input) : press
  end

  private

  def menu(user_input)
    case user_input
    when '1'
      dial
    when '2'
      voicemail
    else
      press(false)
    end
  end

  def dial
    res.dial(action: '/update', number: CELL)
  end

  def voicemail
    res.record(action: '/update', timeout: 0)
  end

  def press(input = true)
    invalid_input(res) unless input
    res.gather(numDigits: 1) { |g| g.say(message: MENU) }
    res.redirect '/call'
  end

  def invalid_input(res)
    res.say(message: INVALID_INPUT)
    res.pause
  end

end
