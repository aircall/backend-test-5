class Calls::RecordedController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    # in this case, the VOIP::Webhook service use the same attributes than the model, but a matching could be required
    recording_params = VOIP::Webhook.recording_params(params)
    @recording = Call.find_by(provider_sid: recording_params.delete(:call_provider_sid)).create_recording(recording_params)

    render xml: VOIP::Response.new.say!(I18n.t('voice.messages.hangup'))
  end
end