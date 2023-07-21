#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
@Desc   ：preventing timing attack Against Hash
"""
import hmac
import hashlib

key = "e179017a-62b0-4996-8a38-e91aa9f1"
msg = "Test"

def sign(pre_key, imsg, alg):
    return hmac.new(pre_key, imsg, alg).digest()

def verify(msg, sig):
    return hmac.compare_digest(sig, sign(key, msg, hashlib.sha256)) #good
