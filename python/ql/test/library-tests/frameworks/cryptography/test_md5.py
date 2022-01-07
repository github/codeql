from cryptography.hazmat.primitives import hashes

from binascii import hexlify


hasher = hashes.Hash(hashes.MD5())
hasher.update(b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=MD5

digest = hasher.finalize()
print(hexlify(digest).decode('utf-8'))
