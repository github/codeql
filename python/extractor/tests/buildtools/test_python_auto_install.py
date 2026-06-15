#!/usr/bin/env python

import buildtools.semmle.requirements as requirements
import unittest

class RequirementsTests(unittest.TestCase):

    def assertExpected(self, reqs, expected):
        self.assertEqual(str(reqs), str(requirements.parse(expected.splitlines())))

    _input = """\
        SQLAlchemy<1.1.0,>=1.0.10 # MIT
        sqlalchemy-migrate>=0.9.6 # Apache-2.0
        stevedore>=1.10.0a4 # Apache-2.0
        WebOb>1.2.3 # MIT
        oslo.i18n!=2.1.0,==2.0.7 # Apache-2.0
        foo>=0.9,<0.8 # Contradictory
        bar>=1.3, <1.3 # Contradictory, but only just
        baz>=3 # No dot in version number.
        git+https://github.com/mozilla/elasticutils.git # Requirement in Git. Should be ignored.
        -e git+https://github.com/Lasagne/Lasagne.git@8f4f9b2#egg=Lasagne==0.2.git # Another Git requirement.
        """

    def test_clean(self):
        reqs = requirements.parse(self._input.splitlines())
        expected = """\
        SQLAlchemy<1.1.0,>=1.0.10
        sqlalchemy-migrate>=0.9.6
        stevedore>=1.10.0a4
        WebOb>1.2.3
        oslo.i18n!=2.1.0,==2.0.7
        foo>=0.9
        bar>=1.3
        baz>=3
        """
        self.assertExpected(requirements.clean(reqs), expected)

    def test_restricted(self):
        reqs = requirements.parse(self._input.splitlines())
        expected = """\
        SQLAlchemy<1.1.0,>=1.0.10,==1.*
        sqlalchemy-migrate>=0.9.6,==0.*
        stevedore>=1.10.0a4,==1.*
        WebOb>1.2.3,==1.*
        oslo.i18n!=2.1.0,==2.0.7
        foo>=0.9,==0.*
        bar>=1.3,==1.*
        baz==3.*,>=3
        """
        self.assertExpected(requirements.restrict(reqs), expected)

if __name__ == "__main__":
    unittest.main()
