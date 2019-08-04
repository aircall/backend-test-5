class CallController < ApplicationController
	def index
		@calls = Call.all().includes(:recording).order(created_at: :desc)
	end
end
