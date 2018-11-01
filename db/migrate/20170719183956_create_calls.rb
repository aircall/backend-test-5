class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string :sid
      t.string :from
      t.string :status
      t.string :action
      t.string :recording_url
      t.string :duration
      t.timestamps
    end
  end
end
