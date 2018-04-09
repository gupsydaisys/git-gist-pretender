class CreateNoteRecords < ActiveRecord::Migration
  def change
    create_table :note_records do |t|
      t.integer :person_record_id
      t.text :text
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
