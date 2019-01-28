class Calls::IncomingsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    # in this case, the VOIP::Webhook service use the same attributes than the model, but a matching could be required
    @call = Call.find_or_create_by(VOIP::Webhook.incoming_params(params))

    render xml: VOIP::Response.new.gather_digit!(calls_sorted_path, I18n.t('voice.messages.gather'))
  end

end
