from cryptography.hazmat.primitives.ciphers import algorithms, Cipher, modes
import os

key = os.urandom(256//8)
iv = os.urandom(16)

algorithm = algorithms.AES(key)
cipher = Cipher(algorithm, mode=modes.CBC(iv))

# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------

# following https://cryptography.io/en/latest/hazmat/primitives/symmetric-encryption/#cryptography.hazmat.primitives.ciphers.Cipher

print("encrypt/decrypt")

secret_message = b"secret message"

padding_len = 16 - (len(secret_message) % 16)
padding = b"\0"*padding_len

encryptor = cipher.encryptor()
print(padding_len)
encrypted = encryptor.update(secret_message) # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationInput=secret_message
encrypted += encryptor.update(padding) # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationInput=padding
encrypted += encryptor.finalize()

print("encrypted={}".format(encrypted))

print()

decryptor = cipher.decryptor()
decrypted = decryptor.update(encrypted) # $ CryptographicOperation CryptographicOperationAlgorithm=AES CryptographicOperationInput=encrypted
decrypted += decryptor.finalize()

decrypted = decrypted[:-padding_len]

print("decrypted={}".format(decrypted))
assert decrypted == secret_message
