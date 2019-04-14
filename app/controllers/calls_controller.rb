class CallsController < ApplicationController
    before_action :find_call, only: [:show, :aircall, :voicemail, :redirected_call, :goodbye]

    def index
        @calls = Call.all.order("id DESC")
    end


    def show
    end


    def hello
        response = twilio_response
        message = "You can press 1 to talk with me or press 2 to leave your voice message."
        response.say(message: message, voice: 'woman', language: 'en')
        response.gather(input: 'dtmf', timeout: 5, num_digits: 1, action: aircall_path)
        @call = Call.create({
          :call_sid => params[:CallSid],
          :caller => params[:Caller],
          :from => params[:FromCountry],
          :call_status => params[:CallStatus]
          })
        render xml: response.to_s
    end


    def aircall
        @call.update({
          :digits => params[:Digits].to_i,
          :call_status => params[:CallStatus]
          })
        response = twilio_response
        case params[:Digits]
            when "1"
              message = "you will be redirected to another number"
              response.say(message: message, voice: 'woman', language: 'en')
              response.dial(action: redirected_call_path, number: "+15556667777")
            when "2"
              message = "Please, leave your message after beep. You can press star to finish your message."
              response.say(message: message, voice: 'woman', language: 'en')
              response.record(action: voicemail_path, timeout: 10, playBeep: true, finishOnKey: '*')
            else
              message = "The input is not valid!. Please, press 1 to talk with me or press 2 to leave your voice message."
              response.say(message: message, voice: 'woman', language: 'en')
              response.gather(action: aircall_path)
        end
        render xml: response.to_s
    end


    def redirected_call
        response = twilio_response
        message = "Thank you for your call. Goodbye"
        response.say(message: message, voice: 'woman', language: 'en')
        render xml: response.to_s
        @call.update({
          :redirected_call_status => params[:DialCallStatus],
          :redirected_call_duration => params[:DialCallDuration].to_i,
          :call_status => "Done"
          })        
    end


    def voicemail
        response = twilio_response
        message = "Your voice is recorded successfully. Goodbye"
        response.say(message: message, voice: 'woman', language: 'en')
        render xml: response.to_s        
        @call.update({
            :voice_url => params[:RecordingUrl], 
            :voice_duration => params[:RecordingDuration].to_i,
            :call_status => "Done"
            })
    end


    private
    def twilio_response
        Twilio::TwiML::VoiceResponse.new
    end

    def find_call
        @call = Call.find_by(:call_sid => params[:CallSid])
    end
end