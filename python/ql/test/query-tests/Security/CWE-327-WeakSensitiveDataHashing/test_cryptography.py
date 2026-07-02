from cryptography.hazmat.primitives import hashes
from binascii import hexlify
from my_module import get_password, get_certificate # $ Source


def get_badly_hashed_certificate():
    dangerous = get_certificate() # $ Source
    hasher = hashes.Hash(hashes.MD5())
    hasher.update(dangerous) # $ Alert # NOT OK
    digest = hasher.finalize()
    return hexlify(digest).decode("utf-8")


def get_badly_hashed_password():
    dangerous = get_password() # $ Source
    hasher = hashes.Hash(hashes.MD5())
    hasher.update(dangerous) # $ Alert # NOT OK
    digest = hasher.finalize()
    return hexlify(digest).decode("utf-8")


def get_badly_hashed_password2():
    dangerous = get_password() # $ Source
    # Although SHA-256 is a strong cryptographic hash functions,
    # it is not suitable for password hashing.
    hasher = hashes.Hash(hashes.SHA256())
    hasher.update(dangerous) # $ Alert # NOT OK
    digest = hasher.finalize()
    return hexlify(digest).decode("utf-8")
