class CreateRecordings < ActiveRecord::Migration[5.1]
  def change
    create_table :recordings do |t|
    	t.references :calls
    	t.integer :duration
    	t.string :url, limit: 200

      t.timestamps
    end
    add_foreign_key :recordings, :calls
  end
end
