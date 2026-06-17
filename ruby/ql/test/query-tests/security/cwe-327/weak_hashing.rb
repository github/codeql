require 'openssl'

password = "abcde" # $ Source[rb/weak-sensitive-data-hashing]
username = "some_user" # $ Source[rb/weak-sensitive-data-hashing]
some_data = "foo"
x = password

Digest::MD5.hexdigest(some_data) # OK: input is not sensitive
Digest::SHA256.hexdigest(password) # OK: strong hash algorithm
Digest::MD5.hexdigest(password) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data
OpenSSL::Digest.digest('SHA1', password) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data
Digest::MD5.hexdigest(username) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data
Digest::MD5.hexdigest(x) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data

def get_safe_data()
  return "hello"
end

def get_password()
  return "changeme"
end

Digest::MD5.hexdigest(get_safe_data()) # OK: input is not sensitive
Digest::MD5.hexdigest(get_password()) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data

some_hash = {password: "changeme", foo: "bar"}
Digest::MD5.hexdigest(some_hash[:foo]) # OK: input is not sensitive
Digest::MD5.hexdigest(some_hash[:password]) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data

def a_method(safe_data, password_param) # $ Source[rb/weak-sensitive-data-hashing]
  Digest::MD5.hexdigest(safe_data) # OK: input is not sensitive
  Digest::MD5.hexdigest(password_param) # $ Alert[rb/weak-sensitive-data-hashing] // BAD: weak hash function used for sensitive data
end
