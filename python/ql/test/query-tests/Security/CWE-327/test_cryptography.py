from cryptography.hazmat.primitives.ciphers import Cipher, algorithms

def get_badly_encrypted_password():
    dangerous = get_password()
    cipher = Cipher(algorithms.ARC4(key), _, _)
    encryptor = cipher.encryptor()
    return encryptor.update(dangerous) + encryptor.finalize()

