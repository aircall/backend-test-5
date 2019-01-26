class Calls::IncomingsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @call = Call.create(VOIP::Webhook.incoming_params(params)) # in this case, the VOIP::Webhook service use the same attributes than the model, but a matching could be required
    render xml: VOIP::Response.new.gather_digit!(calls_sorted_path, I18n.t('voice.messages.gather'))
  end

end
