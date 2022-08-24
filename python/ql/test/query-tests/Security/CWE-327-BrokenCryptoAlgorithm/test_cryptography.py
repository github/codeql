# snippet from python/ql/test/experimental/library-tests/frameworks/cryptography/test_rc4.py
from cryptography.hazmat.primitives.ciphers import algorithms, modes, Cipher
import os

key = os.urandom(256//8)

algorithm = algorithms.ARC4(key)
cipher = Cipher(algorithm, mode=None)

secret_message = b"secret message"

encryptor = cipher.encryptor()
encrypted = encryptor.update(secret_message) # NOT OK
encrypted += encryptor.finalize()

print(secret_message, encrypted)

algorithm = algorithms.AES(key)
cipher = Cipher(algorithm, mode=modes.ECB())

encryptor = cipher.encryptor()
encrypted = encryptor.update(secret_message + b'\x80\x00') # NOT OK
encrypted += encryptor.finalize()

print(secret_message, encrypted)
