from cryptography.hazmat.primitives.ciphers import Cipher, algorithms
from secrets_store import get_password

def get_badly_encrypted_password():
    dangerous = get_password()
    cipher = Cipher(algorithms.ARC4(key), _, _)
    encryptor = cipher.encryptor()
    return encryptor.update(dangerous) + encryptor.finalize()

