from cryptography.hazmat import backends
from cryptography.hazmat.primitives.asymmetric import ec, dsa, rsa

# Crypto and Cryptodome have same API
if random():
    from Crypto.PublicKey import DSA
    from Crypto.PublicKey import RSA
else:
    from Cryptodome.PublicKey import DSA
    from Cryptodome.PublicKey import RSA

RSA_WEAK = 1024
RSA_OK = 2048
RSA_STRONG = 3076

DSA_WEAK = 1024
DSA_OK = 2048
DSA_STRONG = 3076

BIG = 10000

EC_WEAK = ec.SECP224R1()
EC_OK = ec.SECP256R1()
EC_STRONG = ec.SECP384R1()
EC_BIG = ec.SECT571R1()

dsa_gen_key = dsa.generate_private_key
ec_gen_key = ec.generate_private_key
rsa_gen_key = rsa.generate_private_key



# Strong and OK keys.

dsa_gen_key(key_size=DSA_OK)
dsa_gen_key(key_size=DSA_STRONG)
dsa_gen_key(key_size=BIG)
ec_gen_key(curve=EC_OK)
ec_gen_key(curve=EC_STRONG)
ec_gen_key(curve=EC_BIG)
rsa_gen_key(public_exponent=65537, key_size=RSA_OK)
rsa_gen_key(public_exponent=65537, key_size=RSA_STRONG)
rsa_gen_key(public_exponent=65537, key_size=BIG)

DSA.generate(bits=RSA_OK)
DSA.generate(bits=RSA_STRONG)
RSA.generate(bits=RSA_OK)
RSA.generate(bits=RSA_STRONG)

dsa_gen_key(DSA_OK)
dsa_gen_key(DSA_STRONG)
dsa_gen_key(BIG)
ec_gen_key(EC_OK)
ec_gen_key(EC_STRONG)
ec_gen_key(EC_BIG)
rsa_gen_key(65537, RSA_OK)
rsa_gen_key(65537, RSA_STRONG)
rsa_gen_key(65537, BIG)

DSA.generate(DSA_OK)
DSA.generate(DSA_STRONG)
RSA.generate(RSA_OK)
RSA.generate(RSA_STRONG)


# Weak keys

dsa_gen_key(DSA_WEAK) # $ Alert
ec_gen_key(EC_WEAK) # $ Alert
rsa_gen_key(65537, RSA_WEAK) # $ Alert

dsa_gen_key(key_size=DSA_WEAK) # $ Alert
ec_gen_key(curve=EC_WEAK) # $ Alert
rsa_gen_key(65537, key_size=RSA_WEAK) # $ Alert

DSA.generate(DSA_WEAK) # $ Alert
RSA.generate(RSA_WEAK) # $ Alert

# ------------------------------------------------------------------------------

# Through function calls

def make_new_rsa_key_weak(bits):
    return RSA.generate(bits) # $ Alert # NOT OK
make_new_rsa_key_weak(RSA_WEAK)


def make_new_rsa_key_strong(bits):
    return RSA.generate(bits) # OK
make_new_rsa_key_strong(RSA_STRONG)


def only_used_by_test(bits):
    # Although this call will technically not be ok, since it's only used in a test, we don't want to alert on it.
    return RSA.generate(bits)
