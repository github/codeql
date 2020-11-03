#!/usr/bin/env python

from __future__ import unicode_literals

# Allow direct execution
import os
import sys
import unittest
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


import json
from youtube_dl.update import rsa_verify


class TestUpdate(unittest.TestCase):
    def test_rsa_verify(self):
        UPDATES_RSA_KEY = (0x9d60ee4d8f805312fdb15a62f87b95bd66177b91df176765d13514a0f1754bcd2057295c5b6f1d35daa6742c3ffc9a82d3e118861c207995a8031e151d863c9927e304576bc80692bc8e094896fcf11b66f3e29e04e3a71e9a11558558acea1840aec37fc396fb6b65dc81a1c4144e03bd1c011de62e3f1357b327d08426fe93, 65537)
        with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'versions.json'), 'rb') as f:
            versions_info = f.read().decode()
        versions_info = json.loads(versions_info)
        signature = versions_info['signature']
        del versions_info['signature']
        self.assertTrue(rsa_verify(
            json.dumps(versions_info, sort_keys=True).encode('utf-8'),
            signature, UPDATES_RSA_KEY))


if __name__ == '__main__':
    unittest.main()
