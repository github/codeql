require 'openssl'

def get_password_hash(password, salt)
  OpenSSL::Digest.new('SHA256').digest(password + salt) # BAD
end
