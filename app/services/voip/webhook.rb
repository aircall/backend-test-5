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

    def self.recording_params(params)
      recording_params = params.permit(:RecordingSid, :RecordingUrl, :CallSid, :RecordingStartTime, :RecordingDuration)
      {
        duration_s: recording_params[:RecordingDuration],
        provider_sid: recording_params[:RecordingSid],
        started_at: recording_params[:RecordingStartTime],
        url: recording_params[:RecordingUrl],
        call_provider_sid: recording_params[:CallSid]
      }
    end

    def self.gather_params(params)
      gather_params = params.permit(:CallSid)
      {
        call_provider_sid: gather_params[:CallSid]
      }
    end

    def self.status_params(params)
      status_params = params.permit(:Timestamp, :CallSid, :CallStatus, :CallDuration)
      {
        end_at: status_params[:Timestamp],
        status: status_params[:CallStatus].downcase.to_sym,
        duration_s: status_params[:CallDuration],
        provider_sid: status_params[:CallSid],
        call_provider_sid: status_params[:CallSid]
      }
    end

  end
end