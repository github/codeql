# see https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa.html

from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import hashes
from cryptography.exceptions import InvalidSignature


private_key = ec.generate_private_key(curve=ec.SECP384R1()) # $ PublicKeyGeneration keySize=384
private_key = ec.generate_private_key(curve=ec.SECP384R1) # $ PublicKeyGeneration keySize=384
public_key = private_key.public_key()

HASH_ALGORITHM = hashes.SHA256()

# ------------------------------------------------------------------------------
# sign/verify
# ------------------------------------------------------------------------------

print("sign/verify")

SIGNATURE_ALGORITHM = ec.ECDSA(HASH_ALGORITHM)

message = b"message"

signature = private_key.sign(
    message,
    signature_algorithm=SIGNATURE_ALGORITHM,
)

print("signature={}".format(signature))

print()

public_key.verify(
    signature, message, signature_algorithm=SIGNATURE_ALGORITHM
)
print("Signature verified (as expected)")

try:
    public_key.verify(
        signature, b"other message", signature_algorithm=SIGNATURE_ALGORITHM
    )
    raise Exception("Signature verified (unexpected)")
except InvalidSignature:
    print("Signature mismatch (as expected)")
