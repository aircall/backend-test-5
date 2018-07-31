class ApplicationController < ActionController::Base
  # Removed this to simplify the handling of Twilio requests which don't provide CSRF tokens
  #protect_from_forgery with: :exception
end
