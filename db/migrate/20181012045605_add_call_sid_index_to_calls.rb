class AddCallSidIndexToCalls < ActiveRecord::Migration[5.2]
  def change
    add_index :calls, :call_sid, unique: true
    add_index :calls, :created_at
  end
end
