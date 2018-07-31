class AddCallEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :call_events, :text, default: '[]'
  end
end
