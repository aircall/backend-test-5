class AddAttributesToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :call_sid, :string
    add_column :calls, :caller, :string
    add_column :calls, :digits, :integer
    add_column :calls, :from, :string
    add_column :calls, :call_duration, :integer
    add_column :calls, :voice_url, :string
    add_column :calls, :redirected_call_status, :string
    add_column :calls, :redirected_call_duration, :integer
    add_column :calls, :voice_duration, :integer
    add_column :calls, :call_status, :string
  end
end
