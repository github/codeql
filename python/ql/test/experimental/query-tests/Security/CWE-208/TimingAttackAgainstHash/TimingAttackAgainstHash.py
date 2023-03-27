#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Timing Attack Against Hash
"""
import hashlib
import hmac
from cryptography.hazmat.primitives import cmac
from cryptography.hazmat.primitives.ciphers import algorithms
from Crypto.Signature import pkcs1_15
from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA


def UnsafeCmacCheck(actualCmac):
    expected = cmac.CMAC(algorithms.AES(key))
    expected.update(b"message to authenticate")
    expected.finalize()
    return actualCmac == expected 


def UnsafeCheckSignature(expected):
    message = b'To be signed'
    key = RSA.import_key(open('private_key.der').read())
    h = SHA256.new(message)
    signature = pkcs1_15.new(key).sign(h)
    return expected == signature 

def sign(pre_key, msg, alg):
    return hmac.new(pre_key, msg, alg).digest()

def verifyGood(msg, sig):
    return constant_time_string_compare(sig, sign(key, msg, hashlib.sha256)) #good
 
def verifyBad(msg, sig):
    key = "e179017a-62b0-4996-8a38-e91aa9f1"
    return sig == sign(key, msg, hashlib.sha256) #bad

def constant_time_string_compare(a, b):
    if len(a) != len(b):
        return False

    result = 0

    for x, y in zip(a, b):
        result |= ord(x) ^ ord(y)

    return result == 0
