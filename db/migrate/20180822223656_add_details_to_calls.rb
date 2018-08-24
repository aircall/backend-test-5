class AddDetailsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :to, :string
    add_column :calls, :from, :string
    add_column :calls, :sid, :string
    add_column :calls, :status, :string
    add_column :calls, :duration, :string
    add_column :calls, :voicemail, :string
  end
end
