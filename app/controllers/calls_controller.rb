class CallsController < ApplicationController

  def index
    @calls = Call.includes(:recording).order(created_at: :desc).all
  end

end
