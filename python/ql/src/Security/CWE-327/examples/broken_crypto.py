from Crypto.Cipher import DES, Blowfish

cipher = DES.new(SECRET_KEY)

def send_encrypted(channel, message):
    channel.send(cipher.encrypt(message)) # BAD: weak encryption


cipher = AES.new(SECRET_KEY)

def send_encrypted(channel, message):
    channel.send(cipher.encrypt(message)) # GOOD: strong encryption

