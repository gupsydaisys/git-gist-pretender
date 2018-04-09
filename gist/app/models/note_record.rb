class NoteRecord < ActiveRecord::Base
  default_scope -> { where(deleted_at: nil) }

  # @person_record can be associated with a note but does not have to exist
  belongs_to :person_record
end
