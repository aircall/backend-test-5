# The VOIP part of this application is currently delegated to Twilio services
# If you want to change, you just have to update the services in the app/services/voip folder
require 'twilio-ruby'

module VOIP
  class Gather

    def initialize(params)
      @params = params
    end

    def digit
      @params['Digits'].to_i
    end

  end
end