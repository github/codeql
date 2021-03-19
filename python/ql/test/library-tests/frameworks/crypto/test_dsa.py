# DSA is a public-key algorithm for signing messages.
# Following example at https://pycryptodome.readthedocs.io/en/latest/src/signature/dsa.html

from Crypto.PublicKey import DSA
from Crypto.Signature import DSS
from Crypto.Hash import SHA256


private_key = DSA.generate(2048) # $ PublicKeyGeneration keySize=2048
public_key = private_key.publickey()

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
