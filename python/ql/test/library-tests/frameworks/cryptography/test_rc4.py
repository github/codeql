from cryptography.hazmat.primitives.ciphers import algorithms, Cipher
import os

key = os.urandom(256//8)

algorithm = algorithms.ARC4(key)
cipher = Cipher(algorithm, mode=None)

# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------

# following https://cryptography.io/en/latest/hazmat/primitives/symmetric-encryption.html#cryptography.hazmat.primitives.ciphers.algorithms.ARC4

print("encrypt/decrypt")

secret_message = b"secret message"

encryptor = cipher.encryptor()
encrypted = encryptor.update(secret_message) # $ CryptographicOperation CryptographicOperationAlgorithm=ARC4 CryptographicOperationInput=secret_message
encrypted += encryptor.finalize()

print("encrypted={}".format(encrypted))

print()

decryptor = cipher.decryptor()
decrypted = decryptor.update(encrypted) # $ CryptographicOperation CryptographicOperationAlgorithm=ARC4 CryptographicOperationInput=encrypted
decrypted += decryptor.finalize()

print("decrypted={}".format(decrypted))
assert decrypted == secret_message
