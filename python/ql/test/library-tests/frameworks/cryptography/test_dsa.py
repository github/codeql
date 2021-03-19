# DSA is a public-key algorithm for signing messages.
# see https://cryptography.io/en/latest/hazmat/primitives/asymmetric/dsa.html

from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import hashes
from cryptography.exceptions import InvalidSignature

HASH_ALGORITHM = hashes.SHA256()

private_key = dsa.generate_private_key(key_size=2048) # $ PublicKeyGeneration keySize=2048
public_key = private_key.public_key()

message = b"message"

# Following example at https://cryptography.io/en/latest/hazmat/primitives/asymmetric/dsa.html#signing

signature = private_key.sign(
    message,
    algorithm=HASH_ALGORITHM,
)

print("signature={}".format(signature))

print()

public_key.verify(
    signature, message, algorithm=HASH_ALGORITHM
)
print("Signature verified (as expected)")

try:
    public_key.verify(
        signature, b"other message", algorithm=HASH_ALGORITHM
    )
    raise Exception("Signature verified (unexpected)")
except InvalidSignature:
    print("Signature mismatch (as expected)")
