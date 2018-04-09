class NoteRecord < ActiveRecord::Base
  default_scope -> { where(deleted_at: nil) }

  # Get all notes by anyone in who is passed in by person_records
  scope :by_person_records, ->(*person_records) { where(person_record: Array.wrap(person_records)) }

  # @person_record can be associated with a note but does not have to exist
  belongs_to :person_record

  # @text must be present but can be blank
  validates :text, presence: true

  def soft_delete
    update_attributes(deleted_at: Time.now)
  end
end
