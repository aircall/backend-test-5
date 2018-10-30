class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string 	:call_sid, null: false
      t.string 	:caller
      t.integer	:call_duration
      t.string	:recording_url
      t.string  :call_status
      t.string  :from, null: false
      t.string  :to, null: false
      t.timestamps
    end
    add_index :calls, :call_sid
  end

  def drop
    remove_table :calls
  end
end
