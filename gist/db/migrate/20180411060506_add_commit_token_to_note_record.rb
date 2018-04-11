class AddCommitTokenToNoteRecord < ActiveRecord::Migration
  def change
    add_column :note_records, :commit_token, :string
  end
end
