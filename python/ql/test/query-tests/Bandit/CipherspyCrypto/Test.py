from Crypto.Cipher import ARC2 as pycrypto_arc2
from Crypto.Cipher import ARC4 as pycrypto_arc4
from Crypto.Cipher import Blowfish as pycrypto_blowfish
from Crypto.Cipher import DES as pycrypto_des
from Crypto.Cipher import XOR as pycrypto_xor
from Cryptodome.Cipher import ARC2 as pycryptodomex_arc2
from Cryptodome.Cipher import ARC4 as pycryptodomex_arc4
from Cryptodome.Cipher import Blowfish as pycryptodomex_blowfish
from Cryptodome.Cipher import DES as pycryptodomex_des
from Cryptodome.Cipher import XOR as pycryptodomex_xor
from Crypto.Hash import SHA
from Crypto import Random
from Crypto.Util import Counter
from cryptography.hazmat.primitives.ciphers import Cipher
from cryptography.hazmat.primitives.ciphers import algorithms
from cryptography.hazmat.primitives.ciphers import modes
from cryptography.hazmat.backends import default_backend
from struct import pack

key = b'Sixteen byte key'
iv = Random.new().read(pycrypto_arc2.block_size)
cipher = pycrypto_arc2.new(key, pycrypto_arc2.MODE_CFB, iv)
msg = iv + cipher.encrypt(b'Attack at dawn')
cipher = pycryptodomex_arc2.new(key, pycryptodomex_arc2.MODE_CFB, iv)
msg = iv + cipher.encrypt(b'Attack at dawn')

key = b'Very long and confidential key'
nonce = Random.new().read(16)
tempkey = SHA.new(key+nonce).digest()
cipher = pycrypto_arc4.new(tempkey)
msg = nonce + cipher.encrypt(b'Open the pod bay doors, HAL')
cipher = pycryptodomex_arc4.new(tempkey)
msg = nonce + cipher.encrypt(b'Open the pod bay doors, HAL')

iv = Random.new().read(bs)
key = b'An arbitrarily long key'
plaintext = b'docendo discimus '
plen = bs - divmod(len(plaintext),bs)[1]
padding = [plen]*plen
padding = pack('b'*plen, *padding)
bs = pycrypto_blowfish.block_size
cipher = pycrypto_blowfish.new(key, pycrypto_blowfish.MODE_CBC, iv)
msg = iv + cipher.encrypt(plaintext + padding)
bs = pycryptodomex_blowfish.block_size
cipher = pycryptodomex_blowfish.new(key, pycryptodomex_blowfish.MODE_CBC, iv)
msg = iv + cipher.encrypt(plaintext + padding)

key = b'-8B key-'
plaintext = b'We are no longer the knights who say ni!'
nonce = Random.new().read(pycrypto_des.block_size/2)
ctr = Counter.new(pycrypto_des.block_size*8/2, prefix=nonce)
cipher = pycrypto_des.new(key, pycrypto_des.MODE_CTR, counter=ctr)
msg = nonce + cipher.encrypt(plaintext)
nonce = Random.new().read(pycryptodomex_des.block_size/2)
ctr = Counter.new(pycryptodomex_des.block_size*8/2, prefix=nonce)
cipher = pycryptodomex_des.new(key, pycryptodomex_des.MODE_CTR, counter=ctr)
msg = nonce + cipher.encrypt(plaintext)

key = b'Super secret key'
plaintext = b'Encrypt me'
cipher = pycrypto_xor.new(key)
msg = cipher.encrypt(plaintext)
cipher = pycryptodomex_xor.new(key)
msg = cipher.encrypt(plaintext)

cipher = Cipher(algorithms.ARC4(key), mode=None, backend=default_backend())
encryptor = cipher.encryptor()
ct = encryptor.update(b"a secret message")

cipher = Cipher(algorithms.Blowfish(key), mode=None, backend=default_backend())
encryptor = cipher.encryptor()
ct = encryptor.update(b"a secret message")

cipher = Cipher(algorithms.IDEA(key), mode=None, backend=default_backend())
encryptor = cipher.encryptor()
ct = encryptor.update(b"a secret message")
