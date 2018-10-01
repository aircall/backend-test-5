class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
    	t.string 	:call_sid
    	t.string 	:number
    	t.integer	:recording_duration
    	t.string	:recording_url
        t.string    :call_status
        t.string    :call_action

    	t.timestamps
    end
  end
end
