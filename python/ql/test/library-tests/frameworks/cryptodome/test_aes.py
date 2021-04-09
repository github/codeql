# https://pycryptodome.readthedocs.io/en/latest/src/cipher/aes.html
from Cryptodome.Cipher import AES

import os

key = os.urandom(256//8)
iv = os.urandom(16)

# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------


print("encrypt/decrypt")

secret_message = b"secret message"

padding_len = 16 - (len(secret_message) % 16)
padding = b"\0"*padding_len

cipher = AES.new(key, AES.MODE_CBC, iv=iv)
# using separate .encrypt calls on individual lines does not work
whole_plantext = secret_message + padding
encrypted = cipher.encrypt(whole_plantext) # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationInput=whole_plantext

print("encrypted={}".format(encrypted))

print()

cipher = AES.new(key, AES.MODE_CBC, iv=iv)
decrypted = cipher.decrypt(encrypted) # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationInput=encrypted

decrypted = decrypted[:-padding_len]

print("decrypted={}".format(decrypted))
assert decrypted == secret_message
