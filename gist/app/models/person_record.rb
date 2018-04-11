class PersonRecord < ActiveRecord::Base
  # @email is not assumed to be real but must be present and match the form XXXX@XXXX.XXXX.  @email must be case
  # insensitively unique since it's used to uniquely identify a PersonRecord in the system.
  validates :email, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "is not of the form XXXX@XXX.XXXX" }

  # @commit_token should be unique, otherwise request already went through
  validates :commit_token, uniqueness: { message: 'indicates request went through.' }

  before_create :generate_token

  # Generates a token for the user to authenticate against
  def generate_token
    self.token = (0...15).map { (65 + rand(26)).chr }.join
  end
end
