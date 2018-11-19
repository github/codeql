from Crypto.Cipher import DES, Blowfish

cipher = DES.new(SECRET_KEY)

def send_encrypted(channel, message):
    channel.send(cipher.encrypt(message)) # BAD: weak encryption


cipher = Blowfish.new(SECRET_KEY)

def send_encrypted(channel, message):
    channel.send(cipher.encrypt(message)) # GOOD: strong encryption

