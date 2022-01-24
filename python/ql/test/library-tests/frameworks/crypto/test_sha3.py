from Crypto.Hash import SHA3_224

hasher = SHA3_224.new(b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA3224
print(hasher.hexdigest())


hasher = SHA3_224.new() # $ CryptographicOperation CryptographicOperationAlgorithm=SHA3224
hasher.update(b"secret") # $ CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=SHA3224
hasher.update(b" message") # $ CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=SHA3224
print(hasher.hexdigest())
