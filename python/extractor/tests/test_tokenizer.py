
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils
from semmle.python.parser import tokenizer
from blib2to3.pgen2.token import tok_name

def unescape(s):
    return u"'" + s.replace(u"\\", u"\\\\").replace(u"\n", u"\\n").replace(u"\t", u"\\t").replace(u"\'", u"\\'") + u"'"


def format_token(token):
    type, text, start, end = token
    # Use Python 3 tokenize style output, regardless of version
    token_range = u"%d,%d-%d,%d:" % (start + end)
    return u"%-20s%-15s%s" % (token_range, tok_name[type], unescape(text))

class TokenizerTest(unittest.TestCase):

    def __init__(self, name):
        super(TokenizerTest, self).__init__(name)
        self.test_folder = os.path.join(os.path.dirname(__file__), "tokenizer")

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def compare_tokens(self, filename):
        pyfile = os.path.join(self.test_folder, filename)
        tokenfile = os.path.join(self.test_folder, filename[:-3]+".tokens")
        with open(tokenfile, "rb") as tkns:
            expected = [ line.strip().decode("utf8") for line in tkns if line.strip() ]
        try:
            with open(pyfile, "rb") as srcfile:
                srcbytes = srcfile.read()
            encoding, srcbytes = tokenizer.encoding_from_source(srcbytes)
            text = srcbytes.decode(encoding)
            actual = [format_token(tkn) for tkn in tokenizer.Tokenizer(text).tokens()]
        except Exception as ex:
            print(ex)
            self.fail("Failed to tokenize " + filename)
        if expected == actual:
            return
        actualfile = os.path.join(self.test_folder, filename[:-3]+".actual")
        with open(actualfile, "wb") as out:
            for line in actual:
                out.write(line.encode("utf8"))
                out.write(b"\n")
        lineno = 1
        for expected_tkn, actual_tkn in zip(expected, actual):
            assert type(expected_tkn) is str
            assert type(actual_tkn) is str
            self.assertEqual(expected_tkn, actual_tkn, " at %s:%d" % (filename[:-3]+".tokens", lineno))
            lineno += 1
        self.assertTrue(len(expected) == len(actual), "Too few or too many tokens for %s" % filename)

    def test_tokens(self):
        for file in os.listdir(self.test_folder):
            if file.endswith(".py"):
                self.compare_tokens(file)
