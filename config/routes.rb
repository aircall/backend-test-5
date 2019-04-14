Rails.application.routes.draw do
    get "call/index"
    root "calls#index"
    
    match 'hello' => 'calls#hello', via: [:get, :post], as: 'hello'
    match 'aircall' => 'calls#aircall', via: [:get, :post], as: 'aircall'
    match 'voicemail' => 'calls#voicemail', via: [:get, :post], as: 'voicemail'
    match 'redirected_call' => 'calls#redirected_call', via: [:get, :post], as: 'redirected_call'    
    match 'goodbye' => 'calls#goodbye', via: [:get, :post], as: 'goodbye'
    match 'show/:CallSid' => 'calls#show', via: [:get], as: 'show'
end
