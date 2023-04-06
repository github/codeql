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
