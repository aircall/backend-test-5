class CallsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:status]

  def index
    @calls = Call.all
  end

end
