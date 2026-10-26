import hmac
import hashlib

key = b"<secret key>"

hmac_obj = hmac.new(key, b"secret message", "sha256") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA256
print(hmac_obj.digest())
print(hmac_obj.hexdigest())

hmac_obj = hmac.new(key, msg=b"secret message", digestmod="sha256") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA256
print(hmac_obj.hexdigest())


hmac_obj = hmac.new(key, digestmod="sha256")
hmac_obj.update(b"secret") # $ CryptographicOperation CryptographicOperationInput=b"secret" CryptographicOperationAlgorithm=SHA256
hmac_obj.update(msg=b" message") # $ CryptographicOperation CryptographicOperationInput=b" message" CryptographicOperationAlgorithm=SHA256
print(hmac_obj.hexdigest())


hmac_obj = hmac.new(key, b"secret message", hashlib.sha256) # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA256
print(hmac_obj.hexdigest())


# like hmac.new
hmac_obj = hmac.HMAC(key, digestmod="sha256")
hmac_obj.update(b"secret message") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA256
print(hmac_obj.hexdigest())


dig = hmac.digest(key, b"secret message", "sha256") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA256
print(dig)
dig = hmac.digest(key, msg=b"secret message", digest="sha256") # $ CryptographicOperation CryptographicOperationInput=b"secret message" CryptographicOperationAlgorithm=SHA256
print(dig)
