namespace :voip do
  desc "Update the VOIP webhooks for this environment"
  task update_webhooks: :environment do
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    if ENV['NUMBER_SID']
      # if a NUMBER_SID is defined, we update the webhooks of this number
      number = @client.incoming_phone_numbers(ENV['NUMBER_SID'])
    else
      #otherwise, we suppose that the Twilio has only one numbers configured
      number = @client.incoming_phone_numbers.list.first
    end
    number.update(  voice_url: ENV['VOICE_WEBHOOK_URL'],
                    status_callback: ENV['STATUS_WEBHOOK_URL'])
  end
end