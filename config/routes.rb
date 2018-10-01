Rails.application.routes.draw do

	root 'calls#index'

	match 'calls/incoming' => 'calls#incoming', via: [:get, :post], as: 'incoming'

	match 'calls/selection' => 'calls#selection', via: [:get, :post], as: 'selection'

	get 'finish_call' => 'calls#finish_call'

end
