# snippet from python/ql/test/experimental/library-tests/frameworks/cryptodome/test_rc4.py
from Cryptodome.Cipher import ARC4

import os

key = os.urandom(256//8)

secret_message = b"secret message"

cipher = ARC4.new(key)
encrypted = cipher.encrypt(secret_message) # NOT OK

print(secret_message, encrypted)
