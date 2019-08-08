class AddColumnsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :from, :string, limit: 20
    add_column :calls, :direction, :string, limit: 20
    add_column :calls, :called, :string, limit: 20
    add_column :calls, :sid, :string, limit: 34
    add_column :calls, :status, :string, limit: 20
    add_column :calls, :forwarding, :integer, default: 0
    add_column :calls, :duration, :integer
  end
end
