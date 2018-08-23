class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string :twilio_id
      t.string :from
      t.string :action
      t.string :status
      t.string :recording_url
      t.integer :duration

      t.timestamps
    end
  end
end
