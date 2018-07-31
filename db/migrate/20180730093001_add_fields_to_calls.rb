class AddFieldsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :duration, :integer
    add_column :calls, :status, :string
    add_column :calls, :voicemail, :string
  end
end
