class UpdateCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :sid, :string, limit: 40
    add_column :calls, :caller, :string, limit: 20
    add_column :calls, :routing, :string, limit: 10
    add_column :calls, :inputs, :string, limit: 100
  end
end
