class CreatePersonRecordsTable < ActiveRecord::Migration
  def change
    create_table :person_records, id: false, primary_key: :identifier do |t|
      t.string :identifier
      t.string :email
      t.string :token
      t.string :commit_token

      t.timestamps null: false
    end
  end
end
