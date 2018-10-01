class Call < ApplicationRecord
	alias_attribute :CallSid, :call_sid
	alias_attribute :Caller, :number
	alias_attribute :RecordingDuration, :recording_duration
	alias_attribute :RecordingUrl, :recording_url
	alias_attribute :CallStatus, :call_status
end