class AddFieldsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :call_sid,  :string
    add_column :calls, :number,    :string
    add_column :calls, :direction, :string
    add_column :calls, :status,    :string
    add_column :calls, :url,       :string
    add_column :calls, :duration,  :string
  end
end
