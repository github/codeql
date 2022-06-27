#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Timing Attack Against Signature
"""
import hashlib
import hmac
from django.utils.crypto import constant_time_compare

key = "e179017a-62b0-4996-8a38-e91aa9f1"

def sign(pre_key, msg, alg):
    return hmac.new(pre_key, msg, alg).digest()

def verify1(msg, sig):
    return constant_time_string_compare(sig, sign(key, msg, hashlib.sha256)) #good
 
def verify2(msg, sig):
    return sig == sign(key, msg, hashlib.sha256) #bad
