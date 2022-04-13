require 'openssl'

class Encryptor
  attr_accessor :secret_key

  def encrypt_message_weak(message)
    cipher = OpenSSL::Cipher.new('des') # BAD: weak encryption
    cipher.encrypt
    cipher.key = secret_key
    cipher.update(message)
    cipher.final
  end

  def encrypt_message_strong(message)
    cipher = OpenSSL::Cipher::AES128.new # GOOD: strong encryption
    cipher.encrypt
    cipher.key = secret_key
    cipher.update(message)
    cipher.final
  end
end
