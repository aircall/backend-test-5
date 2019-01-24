require 'twilio-ruby'
#require 'sanitize'

class CallsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:incoming]

  def incoming
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(num_digits: '1', action: root_path)
    gather.say(message: "Welcome on OzoneCall. Press 1 to Call Julien. Press 2 to leave a message. Thank you.", loop: 2)
    response.append(gather)

    render xml: response.to_s
  end

  def sorting

  end

  def home
    render "test"
  end
end
