class AddChoiceToCall < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :choice, :integer
  end
end
