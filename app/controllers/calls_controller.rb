class CallsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:incoming, :sorting, :recording]

  def incoming
    render xml: VOIP::Response.new.gather_digit!(sorting_calls_path, I18n.t('voice.messages.gather'))
  end

  def sorting
    case VOIP::Gather.new(params).digit
    when 1
      render xml: VOIP::Response.new.forward_to_me(I18n.t('voice.messages.redirect'))
    when 2
      render xml: VOIP::Response.new.say!(I18n.t('voice.messages.leave_message'))
                                   .record!(recording_calls_path)
    else
      render xml: VOIP::Response.new.redirect_to(incoming_calls_path)
    end
  end

  def recording
    render xml: VOIP::Response.new.say!(I18n.t('voice.messages.hangup'))
  end

  def home
    render plain: "test"
  end
end
