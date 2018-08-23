require 'twilio-ruby'

class CallController < ApplicationController
  include Webhookable

  skip_before_action :verify_authenticity_token

  def index
    @calls = Call.all
        render 'calls/index' #, :locals => {:calls => @calls}
  end

  def destroy
    @call = Call.destroy(params['id'])
    head :ok, :content_type => 'text/html'
  end

  def table_refresh
    @calls = Call.all
    render partial: 'calls/table'
  end

  def base_reply
    @call = Call.create(twilio_id: params['CallSid'], from: params['From'], action: 'begin_call', status: 'calling')
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Thank you for calling. Please press one to be forwarded to his personal phone, or two to record a message.', :voice => 'alice'
      r.Gather :input => 'dtmf', :timeout => 10, :numDigits => '1', :action => '/twilio/response'
      r.Say 'No code entered, hanging up'
    end
    set_xml_header
    render_twiml response
  end

  def handle_response
    @call = Call.find_by(twilio_id: params['CallSid'])
    case params['Digits']
    when '1'
      @call.update(action:'forward_call')
      response = Twilio::TwiML::Response.new do |r|
        r.Say('Redirecting you to Alessandro Jeanteur.')
        r.Dial(Rails.application.secrets.personal_number,
               action: '/twilio/redirect_status',)
        r.Say('Goodbye.')
      end
    when '2'
      @call.update(action: 'record_message')
      response = Twilio::TwiML::Response.new do |r|
        r.Say('Will record a message after the tone. Thank you for calling.')
        r.Record(action: '/twilio/recording_started',
                 recordingStatusCallback: '/twilio/recording_finished')
      end
    else
      @call.update(action: 'no_action_taken', status:'call_ended')
      response =  Twilio::TwiML::Response.new do |r|
        r.Say('Invalid message. Goodbye.')
      end
    end
        set_xml_header
    render_twiml response
  end

  def handle_redirect
                @call = Call.find_by(twilio_id: params['CallSid'])
    @call.update(status: params['DialCallStatus'], duration: params['DialCallDuration'])
  end

  def handle_recording_started
                @call = Call.find_by(twilio_id: params['CallSid'])
    @call.update(status:'recording_started', recording_url: params['RecordingUrl'], duration: params['RecordingDuration'])
  end

  def handle_recording_finished
                    @call = Call.find_by(twilio_id: params['CallSid'])
    @call.update(status: 'call_ended', duration: params['RecordingDuration'])
  end

  def update_call_status
    @call = Call.find_by(twilio_id: params['CallSid'])
    @call.update(status: 'call_ended')
  end
  
  private
    def call_params
      params.require(:call).permit(:twilio_id, :from)
    end
end