class CreateNoteRecords < ActiveRecord::Migration
  def change
    create_table :note_records, id: false, primary_key: :identifier do |t|
      t.string :identifier
      t.string :creator_id
      t.text :text
      t.string :commit_token
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
