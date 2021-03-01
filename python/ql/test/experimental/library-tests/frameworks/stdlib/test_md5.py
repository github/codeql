import hashlib


hasher = hashlib.md5(b"secret message") # $ MISSING: CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.md5()
hasher.update(b"secret") # $ MISSING: CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
hasher.update(b" message") # $ MISSING: CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.new('md5', b"secret message") # $ MISSING: CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.new('md5')
hasher.update(b"secret") # $ MISSING: CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
hasher.update(b" message") # $ MISSING: CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())
