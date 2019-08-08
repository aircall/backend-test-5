# frozen_string_literal: true

# Controller for Calls : create method receive new phone call
class CallsController < ApplicationController
  def index
    @call = Call.all.order('created_at DESC').page(page_params[:page]).per(25)
  end
end
