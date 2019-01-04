from Crypto.Cipher import ARC4

def get_badly_encrypted_password():
    dangerous = get_password()
    cipher = ARC4.new(_, _)
    return cipher.encrypt(dangerous)

