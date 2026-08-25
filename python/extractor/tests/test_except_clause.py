import unittest
from contextlib import contextmanager

from semmle import util
from semmle.python import ast
from semmle.python import parser
from semmle.python.parser.dump_ast import StdoutLogger
from semmle.python.parser.tokenizer import Tokenizer


@contextmanager
def analysis_version(version):
    'Extract as if `CODEQL_EXTRACTOR_PYTHON_ANALYSIS_VERSION` were `version`.'
    previous = util.get_analysis_version()
    util.update_analysis_version(version)
    try:
        yield
    finally:
        util.update_analysis_version(previous)


class ExceptClauseTest(unittest.TestCase):
    '''`except_clause: 'except' [test [(',' | 'as') test]]` is one grammar rule
    covering two incompatible readings of `except A, B:` -- a Python 2 alias
    binding and a PEP 758 tuple of exception types. Which one the default parser
    picks depends on the version being extracted, so these tests pin both.
    '''

    def handler(self, source):
        'The first `except` handler of the first statement of `source`.'
        with StdoutLogger() as logger:
            module = parser.parse(Tokenizer(source).tokens(), logger)
        return module.body[0].handlers[0]

    def test_comma_is_a_tuple_of_types_in_python_3(self):
        with analysis_version("3.11"):
            handler = self.handler("try:\n    a\nexcept b, c:\n    d\n")
        self.assertIsNone(handler.name)
        self.assertIsInstance(handler.type, ast.Tuple)
        self.assertIsInstance(handler.type.ctx, ast.Load)
        self.assertEqual(["b", "c"], [elt.id for elt in handler.type.elts])
        for elt in handler.type.elts:
            self.assertIsInstance(elt.ctx, ast.Load)

    def test_comma_is_an_alias_binding_in_python_2(self):
        with analysis_version("2.7.18"):
            handler = self.handler("try:\n    a\nexcept b, c:\n    d\n")
        self.assertIsInstance(handler.type, ast.Name)
        self.assertEqual("b", handler.type.id)
        self.assertIsInstance(handler.type.ctx, ast.Load)
        self.assertIsInstance(handler.name, ast.Name)
        self.assertEqual("c", handler.name.id)
        self.assertIsInstance(handler.name.ctx, ast.Store)

    def test_as_is_an_alias_binding_in_both_versions(self):
        for version in ("3.11", "2.7.18"):
            with analysis_version(version):
                handler = self.handler("try:\n    a\nexcept b as c:\n    d\n")
            self.assertIsInstance(handler.type, ast.Name, version)
            self.assertEqual("b", handler.type.id, version)
            self.assertIsInstance(handler.name, ast.Name, version)
            self.assertEqual("c", handler.name.id, version)
            self.assertIsInstance(handler.name.ctx, ast.Store, version)

    def test_parenthesised_types_bind_no_alias_in_either_version(self):
        for version in ("3.11", "2.7.18"):
            with analysis_version(version):
                handler = self.handler("try:\n    a\nexcept (b, c):\n    d\n")
            self.assertIsNone(handler.name, version)
            self.assertIsInstance(handler.type, ast.Tuple, version)
            self.assertEqual(["b", "c"], [elt.id for elt in handler.type.elts], version)
