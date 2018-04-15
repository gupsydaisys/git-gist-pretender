class DropNoteRecord < ActiveRecord::Migration
  def change
    drop_table :note_records
  end
end
