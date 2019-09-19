class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string :status
      t.integer :duration
      t.string :voicemail_url
      t.string :caller
      t.timestamps
    end
  end
end
