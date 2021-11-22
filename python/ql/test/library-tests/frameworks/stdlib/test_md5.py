import hashlib


hasher = hashlib.md5(b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.md5(string=b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.md5()
hasher.update(b"secret") # $ CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
hasher.update(b" message") # $ CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.new('md5', b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.new('md5', data=b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


hasher = hashlib.new('md5')
hasher.update(b"secret") # $ CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
hasher.update(b" message") # $ CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
print(hasher.hexdigest())


def foo(arg):
    hasher = hashlib.new(arg)
    hasher.update(b"secret") # $ CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=MD5
    hasher.update(b" message") # $ CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=MD5
    print(hasher.hexdigest())

foo("md5")
