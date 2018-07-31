class AddCallerNumber < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :caller_number, :string
  end
end
