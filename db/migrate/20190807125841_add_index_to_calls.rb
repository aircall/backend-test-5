class AddIndexToCalls < ActiveRecord::Migration[5.1]
   # A Call SID is the unique ID for any
   # voice call created by Twilio’s API.
   # It is a 34 character string that starts with CA
  def change
    add_index :calls, :sid, unique: true
  end
end
