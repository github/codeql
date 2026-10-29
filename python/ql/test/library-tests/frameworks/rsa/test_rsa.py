# Following examples from https://stuvel.eu/python-rsa-doc/usage.html
import rsa

# using a rather low keysize, since otherwise it takes quite long to run.
(public_key, private_key) = rsa.newkeys(512) # $ PublicKeyGeneration keySize=512
(public_key, private_key) = rsa.newkeys(nbits=512) # $ PublicKeyGeneration keySize=512


# ------------------------------------------------------------------------------
# encrypt/decrypt
# ------------------------------------------------------------------------------

# Note: These are using PKCS#1 v1.5

print("encrypt/decrypt")

secret_message = b"secret message"

encrypted = rsa.encrypt(secret_message, public_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=secret_message
encrypted = rsa.encrypt(message=secret_message, pub_key=public_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=secret_message

print("encrypted={}".format(encrypted))

print()

decrypted = rsa.decrypt(encrypted, private_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=encrypted
decrypted = rsa.decrypt(crypto=encrypted, priv_key=private_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=encrypted

print("decrypted={}".format(decrypted))
assert decrypted == secret_message

print("\n---\n")

# ------------------------------------------------------------------------------
# sign/verify
# ------------------------------------------------------------------------------

# Note: These are using PKCS#1 v1.5

print("sign/verify")

message = b"message"
other_message = b"other message"

hash = rsa.compute_hash(message, "SHA-256") # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
hash = rsa.compute_hash(message=message, method_name="SHA-256") # $ CryptographicOperation CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
signature_from_hash = rsa.sign_hash(hash, private_key, "SHA-256") # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=hash
signature_from_hash = rsa.sign_hash(hash_value=hash, priv_key=private_key, hash_method="SHA-256") # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=hash

signature = rsa.sign(message, private_key, "SHA-256") # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message
signature = rsa.sign(message=message, priv_key=private_key, hash_method="SHA-256") # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationAlgorithm=SHA256 CryptographicOperationInput=message

assert signature == signature_from_hash

print("signature={}".format(signature))

print()

rsa.verify(message, signature, public_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=message CryptographicOperationInput=signature
rsa.verify(message=message, signature=signature, pub_key=public_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=message CryptographicOperationInput=signature

print("Signature verified (as expected)")

try:
    rsa.verify(other_message, signature, public_key) # $ CryptographicOperation CryptographicOperationAlgorithm=RSA CryptographicOperationInput=other_message CryptographicOperationInput=signature
    raise Exception("Signature verified (unexpected)")
except rsa.VerificationError:
    print("Signature mismatch (as expected)")
