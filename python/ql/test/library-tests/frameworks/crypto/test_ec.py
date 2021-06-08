from Crypto.PublicKey import ECC
from Crypto.Signature import DSS
from Crypto.Hash import SHA256


private_key = ECC.generate(curve="P-256") # $ PublicKeyGeneration keySize=256
public_key = private_key.public_key()

# ------------------------------------------------------------------------------
# sign/verify
# ------------------------------------------------------------------------------

print("sign/verify")


message = b"message"

signer = DSS.new(private_key, mode='fips-186-3')

hasher = SHA256.new(message) # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
signature = signer.sign(hasher) # $ CryptographicOperation CryptographicOperationInput=hasher # MISSING: CryptographicOperationAlgorithm=ECDSA

print("signature={}".format(signature))

print()

verifier = DSS.new(public_key, mode='fips-186-3')

hasher = SHA256.new(message) # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
verifier.verify(hasher, signature) # $ CryptographicOperation CryptographicOperationInput=hasher CryptographicOperationInput=signature
print("Signature verified (as expected)")

try:
    hasher = SHA256.new(b"other message") # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=b"other message"
    verifier.verify(hasher, signature) # $ CryptographicOperation CryptographicOperationInput=hasher CryptographicOperationInput=signature # MISSING: CryptographicOperationAlgorithm=ECDSA
    raise Exception("Signature verified (unexpected)")
except ValueError:
    print("Signature mismatch (as expected)")
