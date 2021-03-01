from Crypto.Hash import MD5

hasher = MD5.new(b"secret message") # $ MISSING: CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = MD5.new() # $ MISSING: CryptographicOperation CryptographicOperationAlgorithm=MD5
hasher.update(b"secret") # $ MISSING: CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
hasher.update(b" message") # $ MISSING: CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())
