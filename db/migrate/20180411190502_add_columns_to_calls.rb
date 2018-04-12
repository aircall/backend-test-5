class AddColumnsToCalls < ActiveRecord::Migration[5.1]
  def change
    change_table :calls do |t|
      t.column :to, :string
      t.column :from, :string
      t.column :sid, :string, unique: true
      t.column :status, :string
      t.column :duration, :integer
      t.column :voicemail, :string
    end
  end
end
