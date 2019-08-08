# frozen_string_literal: true

# Controller for Calls : create method receive new phone call
class CallsController < ApplicationController
  def index
    @calls = Call.all.order('created_at DESC').page params[:page]
  end

end
