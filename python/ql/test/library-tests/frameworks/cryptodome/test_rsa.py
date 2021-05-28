# RSA is a public-key algorithm for encrypting and signing messages.

from Cryptodome.PublicKey import RSA
from Cryptodome.Cipher import PKCS1_OAEP
from Cryptodome.Signature import pss
from Cryptodome.Hash import SHA256

private_key = RSA.generate(2048) # $ PublicKeyGeneration keySize=2048

# These 2 methods do the same
public_key = private_key.publickey()
public_key = private_key.public_key()

# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------

print("encrypt/decrypt")

secret_message = b"secret message"

# Following example at https://pycryptodome.readthedocs.io/en/latest/src/examples.html#encrypt-data-with-rsa

encrypt_cipher = PKCS1_OAEP.new(public_key)

encrypted = encrypt_cipher.encrypt(secret_message) # $ CryptographicOperation CryptographicOperationInput=secret_message # MISSING: CryptographicOperationAlgorithm=RSA-OAEP?

print("encrypted={}".format(encrypted))

print()

decrypt_cipher = PKCS1_OAEP.new(private_key)

decrypted = decrypt_cipher.decrypt(encrypted) # $ CryptographicOperation CryptographicOperationInput=encrypted # MISSING: CryptographicOperationAlgorithm=RSA-OAEP?

print("decrypted={}".format(decrypted))
assert decrypted == secret_message

print("\n---\n")

# ------------------------------------------------------------------------------
# sign/verify
# ------------------------------------------------------------------------------

print("sign/verify")


message = b"message"

signer = pss.new(private_key)

hasher = SHA256.new(message) # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
signature = signer.sign(hasher) # $ CryptographicOperation CryptographicOperationInput=hasher # MISSING: CryptographicOperationAlgorithm=RSA-PSS?

print("signature={}".format(signature))

print()

verifier = pss.new(public_key)

hasher = SHA256.new(message) # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
verifier.verify(hasher, signature) # $ CryptographicOperation CryptographicOperationInput=hasher CryptographicOperationInput=signature # MISSING: CryptographicOperationAlgorithm=RSA-PSS?
print("Signature verified (as expected)")

try:
    verifier = pss.new(public_key)
    hasher = SHA256.new(b"other message") # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=b"other message"
    verifier.verify(hasher, signature) # $ CryptographicOperation CryptographicOperationInput=hasher CryptographicOperationInput=signature # MISSING: CryptographicOperationAlgorithm=RSA-PSS?
    raise Exception("Signature verified (unexpected)")
except ValueError:
    print("Signature mismatch (as expected)")
