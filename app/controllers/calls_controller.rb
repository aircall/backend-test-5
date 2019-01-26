class CallsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:status]

  def home
    render plain: "test"
  end

  def status
    render xml: VOIP::Response.new
  end
end
