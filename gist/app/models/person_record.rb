class PersonRecord < ActiveRecord::Base
  # @email is not assumed to be real but must be present and match the form XXXX@XXXX.XXXX.  @email must be case
  # insensitively unique since it's used to uniquely identify a PersonRecord in the system.
  validates :email, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "is not of the form XXXX@XXX.XXXX" }

  # @token must be present.  Assumes this data is being handled with care :eek:
  validates :token, presence: true
end
