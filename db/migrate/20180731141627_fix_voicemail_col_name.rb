class FixVoicemailColName < ActiveRecord::Migration[5.1]
  def change
    rename_column :calls, :voicemail, :voicemail_url
    remove_column :calls, :duration
  end
end
