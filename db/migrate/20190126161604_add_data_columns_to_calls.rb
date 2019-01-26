class AddDataColumnsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :country, :string
    add_column :calls, :provider_sid, :string
    add_column :calls, :phone_number, :string
    add_column :calls, :end_at, :datetime
  end
end
