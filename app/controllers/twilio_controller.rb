require 'twilio-ruby'

class TwilioController < ApplicationController
	skip_before_action :verify_authenticity_token

	def initial
		sid = params[:CallSid]
		caller = params[:From]
		@call = Call.new(sid: sid, caller: caller)
        @call.save

		response = Twilio::TwiML::VoiceResponse.new
		response.gather(num_digits: '1', action: url_for(controller: 'twilio', action: 'keys')) do |gather|
			gather.say(message: 'Press 1 to be forwarded. Press 2 to leave a message.')
		end
		render xml: response
	end

	def keys
		sid = params[:CallSid]
		choice = params[:Digits]
		@call = Call.find_by(sid: sid)
		@call.inputs = @call.inputs.to_s + choice.to_s

		case choice
		when '1'
			handle_forward
		when '2'
			handle_voicemail
		else
			handle_invalid_input
		end
	end

	def recording
		sid = params[:CallSid]
		url = params[:RecordingUrl]
		duration = params[:RecordingDuration]
		@call = Call.find_by(sid: sid)
		@recording = Recording.new(calls_id: @call.id, duration: duration, url: url)

		response = Twilio::TwiML::VoiceResponse.new
		response.say(message: 'Thank you for leaving a message.')
		response.hangup
		render xml: response
	end

	private
	def handle_forward
		@call.routing = 'forwarded'
		@call.save
		response = Twilio::TwiML::VoiceResponse.new
		response.say(message: 'You are being forwarded')
		response.dial(number: '')
		render xml:response
	end

	def handle_voicemail
		@call.routing = 'voicemail'
		@call.save
		response = Twilio::TwiML::VoiceResponse.new
		response.say(message: 'You will now be able to leave a message. To end it, please press the star key.')
		response.record(action: url_for(controller: 'twilio', action: 'recording'), method: 'GET', max_length: 20, finish_on_key: '*')
		render xml: response
	end

	def handle_invalid_input
		@call.save
		response = Twilio::TwiML::VoiceResponse.new
		response.say(message: 'Unrecognized digit.')
		response.redirect(url_for(controller: 'twilio', action: 'initial'), method: 'POST')
		render xml: response
	end
end
