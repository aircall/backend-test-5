class CallService
  def self.update(sid, new_status, duration, recording_url)
    call = Call.find_by sid: sid
    if call
      call.status = new_status
      call.duration = duration
      call.voicemail = recording_url

      call.save
    end
  end

  def self.create(sid, to, from, status)
    call = nil
    unless Call.exists?(sid: sid)
      call_info = {
          sid: sid,
          to: to,
          from: from,
          status: status
      }
      call = Call.new(call_info)
      call.save
    end
      call
  end
end