class AddStatusToCall < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :status, :string, limit: 30
  end
end
