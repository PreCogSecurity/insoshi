# Authentication methods for Person model.
# Extracted from person.rb to improve separation of concerns
# and make the model more maintainable (Rails 2.3.x era).
#
# Usage: include PersonAuthentication in ActiveRecord::Base
# or mix into the Person model.

module PersonAuthentication

  # Authenticates a user by their email address and unencrypted password.
  # Returns the user or nil.
  def self.authenticate(email, password)
    u = find_by_email_and_identity_url(email.downcase.strip, nil) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts a password with the user salt.
  def self.encrypt(password)
    Crypto::Key.from_file("#{RAILS_ROOT}/rsa_key.pub").encrypt(password)
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password)
  end

  # Decrypts the password using the RSA key.
  def decrypt(password)
    Crypto::Key.from_file("#{RAILS_ROOT}/rsa_key").decrypt(password)
  end

  # Returns true if the person's unencrypted password matches the given password.
  def authenticated?(password)
    unencrypted_password == password
  end

  # Returns the unencrypted (raw) password from the database.
  # The gsub trickery is to unescape the key from the DB.
  def unencrypted_password
    # The gsub trickery is to unescape the key from the DB.
    decrypt(crypted_password)#.gsub(/\\n/, "\n")
  end
end