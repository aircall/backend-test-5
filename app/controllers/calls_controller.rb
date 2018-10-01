class CallsController < ApplicationController

	before_action :find_or_create_call, except: [:index]

	def index
		@calls = Call.all
	end

	def incoming
		response = Twilio::TwiML::VoiceResponse.new
		response.gather(num_digits: '1', action: selection_path) do |gather|
			gather.say(message: 'Hello there, please enter 1 for Calvin or enter 2 to 
			  	leave a voicemail. Thank you!')
		end
		response.say(message: 'We didnt receive any input. Please try this number again. Goodbye!')
		render :xml => response.to_xml
	end

	def selection
		response = Twilio::TwiML::VoiceResponse.new

	    case params[:Digits]
	    when "1"
	      	dial_calvin
	    when "2"
	    	@call.update(call_action: "left a voicemail.")

	    	response.say(message: 'Please record your voicemail after the beep!')
	    	response.record(action: '/finish_call', method: 'GET', max_length: 30)
	    	render :xml => response.to_xml
	    else
	    	redirect_to incoming_path
	    end
	end

	def finish_call
	    @call.update(call_params)
	    response = Twilio::TwiML::VoiceResponse.new
	    response.hangup
	    render :xml => response.to_xml
	end

private
	
	def find_or_create_call
		@call = Call.find_by(call_sid: params[:CallSid]) || Call.create(call_params)
	end

    def call_params
    	params.permit(:Caller, :CallSid, :RecordingDuration, 
    		:RecordingUrl, :CallStatus, :call_action );
    end
	
	def dial_calvin
		@call.update(call_action: "called Calvin.")

  		response = Twilio::TwiML::VoiceResponse.new do |r|
      		r.dial( record: 'record-from-ringing-dual',
                    action: '/finish_call',
                    method: 'GET' 
                    ) do |dial| 
      			dial.number(ENV["CALVIN_PHONE"])
      		end
    	end
    	render xml: response.to_xml
  	end
end

