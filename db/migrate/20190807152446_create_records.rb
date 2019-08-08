class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.string :sid, limit: 40
      t.integer :duration
      t.string :link, limit: 150
      t.references :call, foreign_key: true
    end
  end
end