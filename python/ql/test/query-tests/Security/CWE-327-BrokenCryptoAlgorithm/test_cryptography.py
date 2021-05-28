# snippet from python/ql/test/experimental/library-tests/frameworks/cryptography/test_rc4.py
from cryptography.hazmat.primitives.ciphers import algorithms, Cipher
import os

key = os.urandom(256//8)

algorithm = algorithms.ARC4(key)
cipher = Cipher(algorithm, mode=None)

secret_message = b"secret message"

encryptor = cipher.encryptor()
encrypted = encryptor.update(secret_message) # NOT OK
encrypted += encryptor.finalize()

print(secret_message, encrypted)
