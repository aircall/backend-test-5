class Calls::IncomingsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    render xml: VOIP::Response.new.gather_digit!(calls_sorted_path, I18n.t('voice.messages.gather'))
  end
end
