require 'openssl'

strong = OpenSSL::Cipher.new 'AES-128-CBC' # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationBlockMode=CBC

weak_algorithm = OpenSSL::Cipher::DES.new # $ CryptographicOperation CryptographicOperationAlgorithm=DES CryptographicOperationBlockMode=CBC

weak_block_mode = OpenSSL::Cipher::AES.new(128, :ecb) # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationBlockMode=ECB

weak_block_mode = OpenSSL::Cipher.new 'bf-ecb' # $ CryptographicOperation CryptographicOperationAlgorithm=BF CryptographicOperationBlockMode=ECB

stream_cipher = OpenSSL::Cipher.new 'chacha' # $ CryptographicOperation CryptographicOperationAlgorithm=CHACHA
