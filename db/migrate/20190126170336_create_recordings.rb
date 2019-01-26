class CreateRecordings < ActiveRecord::Migration[5.1]
  def change
    create_table :recordings do |t|
      t.string :url
      t.references :call
      t.string :provider_sid
      t.datetime :started_at
      t.integer :duration_s

      t.timestamps
    end
  end
end
