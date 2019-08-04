class AddIndexToCalls < ActiveRecord::Migration[5.1]
  def change
    add_index :calls, :sid, unique: true
  end
end
