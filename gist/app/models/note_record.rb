class NoteRecord < ActiveRecord::Base
  self.primary_key = 'identifier'

  def id
    identifier
  end

  before_create :generate_identifier

  default_scope -> { where(deleted_at: nil) }

  # Get all notes by anyone in who is passed in by person_records
  scope :by_person_records, ->(*person_records) { where(person_record: Array.wrap(person_records)) }

  scope :recently_created_first, -> { order('created_at desc') }
  scope :find_by_id, ->(identifier) { where(identifier: identifier).limit(1).first }

  # @person_record can be associated with a note but does not have to exist
  belongs_to :person_record

  # @text must be present but can be blank
  validates :text, presence: true

  # @commit_token should be unique, otherwise request already went through
  validates :commit_token, uniqueness: { message: 'indicates request went through.' }

  def soft_delete
    update_attributes(deleted_at: Time.now)
  end

  # Generates a UUID for the NoteRecord
  def generate_identifier
    self.identifier = Digest::MD5.hexdigest("NoteRecordIdentifier#{commit_token}#{Rails.application.config.try(:hash_salt)}")[0..254]
  end
end
