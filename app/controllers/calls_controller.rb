require 'twilio-ruby'

class CallsController < ApplicationController
  before_action :set_call, only: %i[show edit update destroy]

  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all
  end

  # GET /calls/1
  # GET /calls/1.json
  def show; end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit; end

  # POST /calls
  # POST /calls.json
  def create
    @call = Call.new(call_params)

    respond_to do |format|
      if @call.save
        format.html {redirect_to @call, notice: 'Call was successfully created.'}
        format.json {render :show, status: :created, location: @call}
      else
        format.html {render :new}
        format.json {render json: @call.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  def update
    respond_to do |format|
      if @call.update(call_params)
        format.html {redirect_to @call, notice: 'Call was successfully updated.'}
        format.json {render :show, status: :ok, location: @call}
      else
        format.html {render :edit}
        format.json {render json: @call.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html {redirect_to calls_url, notice: 'Call was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def answer_cb
    logger.debug 'start answer'
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(num_digits: '1', action: gather_url)

    gather.say(message: 'To join a representative, press 1. To leave a voicemail, press 2.')
    response.append(gather)
    # Loop to this menu if no input is gathered within the gather timeout period
    response.redirect(answer_url)

    render xml: response.to_s
  end

  def gather_cb
    logger.debug 'start gather'
    raise ActionController::RoutingError, 'Not Found' unless params['Digits']
    response = Twilio::TwiML::VoiceResponse.new do |r|
      case params['Digits']
      when '1'
        # Ring my phone
        r.say(message: 'Calling a representative')
        r.dial(number: '+33636950509')
      when '2'
        # Record voicemail then redirect to voicemail_url to get its URL
        r.say(message: 'You can now leave a voicemail. Press # when you\'re done.')
        r.record(timeout: 1, finishOnKey: '#', action: voicemail_url)
      else
        # Loop to main endpoint
        r.say(message: 'Returning to main menu.')
        r.redirect answer_url
      end
    end
    render xml: response.to_s
  end

  def voicemail_cb
    logger.debug 'voicemail start'
    raise ActionController::RoutingError, 'Not Found' unless params['RecordingUrl']

    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'We got your message. Thanks for calling!')
      # This is weird. It doesn't hangup right await but seems to wait for a timeout to end.
      # I've noticed it starts happening after the gather in answer_cb
      # For example:
      # responding <Response><Hangup/></Response> at the start of gather_cb doesn't work either.
      # It only works when sent before the gather verb.
      # I did not find significant info/similar error about this.
      # I tried playing with the way gather submits its content (num_of_digits / finishOnKey),
      # changing the Redirect verb after gather, and modify the timeout. None of this seemed to change the behavior
      # Leaving this as is as the call ends up hanging up alone in ~5s
      r.hangup
    end
    logger.debug response.to_s
    render xml: response.to_s
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_call
    @call = Call.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def call_params
    params.fetch(:call, {})
  end
end
