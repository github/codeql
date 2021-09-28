from Crypto.Hash import MD5

hasher = MD5.new(b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = MD5.new() # $ CryptographicOperation CryptographicOperationAlgorithm=MD5
hasher.update(b"secret") # $ CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
hasher.update(b" message") # $ CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())
