from Cryptodome.Hash import MD5, SHA256
from my_module import get_password, get_certificate


def get_badly_hashed_certificate():
    dangerous = get_certificate()
    hasher = MD5.new()
    hasher.update(dangerous) # NOT OK
    return hasher.hexdigest()


def get_badly_hashed_password():
    dangerous = get_password()
    hasher = MD5.new()
    hasher.update(dangerous) # NOT OK
    return hasher.hexdigest()


def get_badly_hashed_password2():
    dangerous = get_password()
    # Although SHA-256 is a strong cryptographic hash functions,
    # it is not suitable for password hashing.
    hasher = SHA256.new()
    hasher.update(dangerous) # NOT OK
    return hasher.hexdigest()
