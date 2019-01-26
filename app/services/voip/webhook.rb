# The VOIP part of this application is currently delegated to Twilio services
# If you want to change, you just have to update the services in the app/services/voip folder
require 'twilio-ruby'

module VOIP
  class Webhook

    def self.incoming_params(params)
      incoming_params = params.permit(:CallerCountry, :CallSid, :From)
      {
        country: incoming_params[:CallerCountry],
        provider_sid: incoming_params[:CallSid],
        phone_number: incoming_params[:From]
      }
    end

  end
end