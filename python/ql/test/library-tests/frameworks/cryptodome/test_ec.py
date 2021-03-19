from Cryptodome.PublicKey import ECC
from Cryptodome.Signature import DSS
from Cryptodome.Hash import SHA256


private_key = ECC.generate(curve="P-256") # $ PublicKeyGeneration keySize=256
public_key = private_key.public_key()

# ------------------------------------------------------------------------------
# sign/verify
# ------------------------------------------------------------------------------

print("sign/verify")


message = b"message"

signer = DSS.new(private_key, mode='fips-186-3')

hasher = SHA256.new(message)
signature = signer.sign(hasher)

print("signature={}".format(signature))

print()

verifier = DSS.new(public_key, mode='fips-186-3')

hasher = SHA256.new(message)
verifier.verify(hasher, signature)
print("Signature verified (as expected)")

try:
    hasher = SHA256.new(b"other message")
    verifier.verify(hasher, signature)
    raise Exception("Signature verified (unexpected)")
except ValueError:
    print("Signature mismatch (as expected)")
