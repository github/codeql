# https://pycryptodome.readthedocs.io/en/latest/src/cipher/arc4.html
from Crypto.Cipher import ARC4

import os

key = os.urandom(256//8)


# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------



print("encrypt/decrypt")

secret_message = b"secret message"

cipher = ARC4.new(key)
encrypted = cipher.encrypt(secret_message) # $ CryptographicOperation CryptographicOperationAlgorithm=ARC4 CryptographicOperationInput=secret_message

print("encrypted={}".format(encrypted))

print()

cipher = ARC4.new(key)
decrypted = cipher.decrypt(encrypted) # $ CryptographicOperation CryptographicOperationAlgorithm=ARC4 CryptographicOperationInput=encrypted

print("decrypted={}".format(decrypted))
assert decrypted == secret_message
