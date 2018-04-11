class AddCommitTokenToPersonRecord < ActiveRecord::Migration
  def change
    add_column :person_records, :commit_token, :string
  end
end
