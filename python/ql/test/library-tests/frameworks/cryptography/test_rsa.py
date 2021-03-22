# RSA is a public-key algorithm for encrypting and signing messages.
# see https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa.html

from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes
from cryptography.exceptions import InvalidSignature


private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048) # $ PublicKeyGeneration keySize=2048
public_key = private_key.public_key()

HASH_ALGORITHM = hashes.SHA256()

# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------

print("encrypt/decrypt")

ENCRYPT_PADDING = padding.OAEP(
    mgf=padding.MGF1(algorithm=HASH_ALGORITHM),
    algorithm=HASH_ALGORITHM,
    label=None,
)


secret_message = b"secret message"

# Following example at https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa.html#encryption
encrypted = public_key.encrypt(secret_message, padding=ENCRYPT_PADDING)

print("encrypted={}".format(encrypted))

print()

decrypted = private_key.decrypt(
    encrypted,
    padding=ENCRYPT_PADDING
)

print("decrypted={}".format(decrypted))
assert decrypted == secret_message

print("\n---\n")

# ------------------------------------------------------------------------------
# sign/verify
# ------------------------------------------------------------------------------

print("sign/verify")

SIGN_PADDING = padding.PSS(
    mgf=padding.MGF1(HASH_ALGORITHM),
    salt_length=padding.PSS.MAX_LENGTH
)

message = b"message"

signature = private_key.sign(
    message,
    padding=SIGN_PADDING,
    algorithm=HASH_ALGORITHM,
)

print("signature={}".format(signature))

print()

public_key.verify(
    signature, message, padding=SIGN_PADDING, algorithm=HASH_ALGORITHM
)
print("Signature verified (as expected)")

try:
    public_key.verify(
        signature, b"other message", padding=SIGN_PADDING, algorithm=HASH_ALGORITHM
    )
    raise Exception("Signature verified (unexpected)")
except InvalidSignature:
    print("Signature mismatch (as expected)")
