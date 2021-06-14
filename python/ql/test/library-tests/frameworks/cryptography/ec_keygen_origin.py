# Since key-size is not specified explicitly as an integer for the predefined
# classes in the `cryptography.hazmat.primitives.asymmetric.ec` module, we need
# special handling of the origin... this test is simply to show off how we handle this.

from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.ec import SECP384R1

ec.generate_private_key(curve=ec.SECP384R1()) # $ PublicKeyGeneration keySize=384
ec.generate_private_key(curve=ec.SECP384R1) # $ PublicKeyGeneration keySize=384

alias = ec.SECP384R1
ec.generate_private_key(curve=alias) # $ PublicKeyGeneration keySize=384

instance = alias()
ec.generate_private_key(curve=instance) # $ PublicKeyGeneration keySize=384


x = SECP384R1
y = x
ec.generate_private_key(curve=y) # $ PublicKeyGeneration keySize=384
