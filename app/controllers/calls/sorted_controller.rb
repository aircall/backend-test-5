class Calls::SortedController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    case VOIP::Gather.new(params).digit
    when 1
      render xml: VOIP::Response.new.forward_to_me(I18n.t('voice.messages.redirect'))
    when 2
      render xml: VOIP::Response.new.say!(I18n.t('voice.messages.leave_message'))
                                   .record!(calls_recorded_path)
    else
      render xml: VOIP::Response.new.redirect_to(calls_incoming_path)
    end
  end
end
