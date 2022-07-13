require 'openssl'

# BAD: creating a cipher using a weak scheme
weak = OpenSSL::Cipher.new('des3')
weak.encrypt
weak.random_key
# BAD: encrypting data using a weak cipher
weak.update('foo')
weak.final

# BAD: creating a cipher using a weak block mode
weak = OpenSSL::Cipher::AES.new(128, 'ecb')
weak.encrypt
weak.random_key
# BAD: encrypting data using a weak block mode
weak.update('foo')
weak.final

# GOOD: creating a cipher using a strong scheme
strong = OpenSSL::Cipher.new('blowfish')
strong.encrypt
strong.random_key
# GOOD: encrypting data using a strong cipher
strong.update('bar')
strong.final

# BAD: weak block mode
OpenSSL::Cipher::AES.new(128, :ecb)
# GOOD: strong encryption algorithm
OpenSSL::Cipher::AES.new(128, 'cbc')
# GOOD: strong encryption algorithm
OpenSSL::Cipher::AES.new('128-cbc')

# GOOD: strong encryption algorithm
OpenSSL::Cipher::AES128.new
# BAD: weak block mode
OpenSSL::Cipher::AES128.new 'ecb'

# GOOD: strong encryption algorithm
OpenSSL::Cipher::AES192.new
# BAD: weak block mode
OpenSSL::Cipher::AES192.new 'ecb'

# GOOD: strong encryption algorithm
OpenSSL::Cipher::AES256.new
# BAD: weak block mode
OpenSSL::Cipher::AES256.new 'ecb'

# GOOD: strong encryption algorithm
OpenSSL::Cipher::BF.new
# BAD: weak block mode
OpenSSL::Cipher::BF.new 'ecb'

# GOOD: strong encryption algorithm
OpenSSL::Cipher::CAST5.new
# BAD: weak block mode
OpenSSL::Cipher::CAST5.new 'ecb'

# BAD: weak encryption algorithm
OpenSSL::Cipher::DES.new
# BAD: weak encryption algorithm
OpenSSL::Cipher::DES.new 'cbc'

# GOOD: strong encryption algorithm
OpenSSL::Cipher::IDEA.new
# BAD: weak block mode
OpenSSL::Cipher::IDEA.new 'ecb'

# BAD: weak encryption algorithm
OpenSSL::Cipher::RC2.new
# BAD: weak encryption algorithm
OpenSSL::Cipher::RC2.new 'ecb'

# BAD: weak encryption algorithm
OpenSSL::Cipher::RC4.new
# BAD: weak encryption algorithm
OpenSSL::Cipher::RC4.new '40'
# BAD: weak encryption algorithm
OpenSSL::Cipher::RC4.new 'hmac-md5'
