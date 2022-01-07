from argon2 import PasswordHasher

def get_initial_hash(password: str):
    ph = PasswordHasher()
    return ph.hash(password) # GOOD

def check_password(password: str, known_hash):
    ph = PasswordHasher()
    return ph.verify(known_hash, password) # GOOD
