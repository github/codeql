from Cryptodome.PublicKey import RSA

from weak_crypto import only_used_by_test

def test_example():
    # This is technically not ok, but since it's in a test, we don't want to alert on it
    RSA.generate(1024)

    only_used_by_test(1024)
