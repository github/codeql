def secret_key
end

def get_password
end

def foo
end

sha1 = OpenSSL::Digest.new('SHA1')

sha1.digest foo # OKAY: not sensitive
sha1.digest get_password # OKAY: ignore passwords, covered by weak password hashing

sha1.digest secret_key # BAD: sensitive data hashed with weak algorithm
sha1 << secret_key # BAD: sensitive data hashed with weak algorithm

k = secret_key

weak = OpenSSL::Cipher.new('des3')
weak.encrypt
weak.random_key
weak.update(k) # BAD: encrypting sensitive data using a weak cipher
weak.update(foo) # OKAY: not sensitive
weak.final

weak = OpenSSL::Cipher::AES.new(128, 'ecb')
weak.encrypt
weak.random_key
weak.update(k) # BAD: encrypting sensitive data using a weak block mode
weak.update(foo) # OKAY: not sensitive
weak.final

strong = OpenSSL::Cipher.new('blowfish')
strong.encrypt
strong.random_key
strong.update(k) # OKAY: encrypting sensitive data using a strong algoithm
strong.final
