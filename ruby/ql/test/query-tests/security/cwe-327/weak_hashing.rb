require 'openssl'

password = "abcde"
username = "some_user"
some_data = "foo"
x = password

Digest::MD5.hexdigest(some_data) # OK: input is not sensitive
Digest::SHA256.hexdigest(password) # OK: strong hash algorithm
Digest::MD5.hexdigest(password) # BAD: weak hash function used for sensitive data
OpenSSL::Digest.digest('SHA1', password) # BAD: weak hash function used for sensitive data
Digest::MD5.hexdigest(username) # BAD: weak hash function used for sensitive data
Digest::MD5.hexdigest(x) # BAD: weak hash function used for sensitive data

def get_safe_data()
  return "hello"
end

def get_password()
  return "changeme"
end

Digest::MD5.hexdigest(get_safe_data()) # OK: input is not sensitive
Digest::MD5.hexdigest(get_password()) # BAD: weak hash function used for sensitive data

some_hash = {password: "changeme", foo: "bar"}
Digest::MD5.hexdigest(some_hash[:foo]) # OK: input is not sensitive
Digest::MD5.hexdigest(some_hash[:password]) # BAD: weak hash function used for sensitive data

def a_method(safe_data, password_param)
  Digest::MD5.hexdigest(safe_data) # OK: input is not sensitive
  Digest::MD5.hexdigest(password_param) # BAD: weak hash function used for sensitive data
end
