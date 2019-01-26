class AddDurationSToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :duration_s, :integer
  end
end
