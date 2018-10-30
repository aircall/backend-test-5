class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :current_call, except: :index
  after_action :update_call_record, only: :handle_input

  def index
    @calls = ::Call.all
  end

  def create
    create_call_record
    render xml: ::TwilioClient.welcome_and_provide_options.to_xml
  end

  def handle_input
    # params[:Digits] is the input recieved from a user signaling their option choice
    user_input = params[:Digits].to_i
    case user_input
    when 1
      render xml: ::TwilioClient.call(::TwilioClient::PERSONAL_NUMBER).to_xml
    when 2
      render xml: ::TwilioClient.record_voicemail.to_xml
    else
      render xml: ::TwilioClient.handle_invalid_key_press.to_xml
    end
  end

  def handle_invalid_input
    render xml: ::TwilioClient.welcome_and_provide_options.to_xml
  end

  # This is an endpoint for when the status of a call changes
  def change_status
    update_call_record
  end

  private

  def update_call_record
    current_call.update_attributes(call_params)
  end

  def current_call
    @call ||= ::Call.find_by(call_sid: params[:CallSid])
  end

  def create_call_record
    ::Call.create(call_params)
  end

  def call_params
    params.permit(
      :Caller,
      :CallSid,
      :CallStatus,
      :CallDuration,
      :RecordingUrl,
      :To,
      :From
    )
  end
end
