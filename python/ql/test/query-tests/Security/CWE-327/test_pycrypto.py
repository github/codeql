from Crypto.Cipher import ARC4
from secrets_store import get_password

def get_badly_encrypted_password():
    dangerous = get_password()
    cipher = ARC4.new(_, _)
    return cipher.encrypt(dangerous)

