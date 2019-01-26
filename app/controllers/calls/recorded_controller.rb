class Calls::RecordedController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    render xml: VOIP::Response.new.say!(I18n.t('voice.messages.hangup'))
  end
end