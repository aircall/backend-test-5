class Calls::FinishedController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    # in this case, the VOIP::Webhook service use the same attributes than the model, but a matching could be required
    status_params = VOIP::Webhook.status_params(params)
    if status_params.delete(:status) == :completed
      @call = Call.find_by(status_params.delete(:call_provider_sid)).update(status_params)
    end

    render xml: VOIP::Response.new.gather_digit!(calls_sorted_path, I18n.t('voice.messages.gather'))
  end

end
