class AddCallSid < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :call_sid, :string
  end
end
