class CreatePersonRecords < ActiveRecord::Migration
  def change
    create_table :person_records do |t|
      t.string :email
      t.string :token

      t.timestamps null: false
    end
  end
end
