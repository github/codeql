import sys
import os.path
import shutil
import unittest
import pytest
import warnings

from tests import test_utils
from semmle.python.parser.dump_ast import old_parser, AstDumper, StdoutLogger
from semmle.python.parser.tsg_parser import parse as new_parser
import subprocess

class ParserTest(unittest.TestCase):
    def __init__(self, name):
        super(ParserTest, self).__init__(name)
        self.test_folder = os.path.join(os.path.dirname(__file__), "parser")
        self.maxDiff = None


    @pytest.fixture(autouse=True)
    def capsys(self, capsys):
        self.capsys = capsys

    def compare_parses(self, filename, logger):
        pyfile = os.path.join(self.test_folder, filename)
        stem = filename[:-3]
        oldfile = os.path.join(self.test_folder, stem + ".old")
        newfile = os.path.join(self.test_folder, stem + ".new")
        old_error = False
        new_error = False
        try:
            old_ast = old_parser(pyfile, logger)
            with open(oldfile, "w") as old:
                AstDumper(old).visit(old_ast)
        except SyntaxError:
            old_error = True
        try:
            new_ast = new_parser(pyfile, logger)
            with open(newfile, "w") as new:
                AstDumper(new).visit(new_ast)
        except SyntaxError:
            new_error = True

        if old_error or new_error:
            raise Exception("Parser error: old_error={}, new_error={}".format(old_error, new_error))
        try:
            diff = subprocess.check_output(["git", "diff", "--patience", "--no-index", oldfile, newfile])
        except subprocess.CalledProcessError as e:
            diff = e.output
        if diff:
            pytest.fail(diff.decode("utf-8"))
        self.check_for_stdout_errors(logger)

        self.assertEqual(self.capsys.readouterr().err, "")
        os.remove(oldfile)
        os.remove(newfile)

    def compare_expected(self, filename, logger, new=True ):
        if sys.version_info.major < 3:
            return
        pyfile = os.path.join(self.test_folder, filename)
        stem = filename[:-3]
        expected = os.path.join(self.test_folder, stem + ".expected")
        actual = os.path.join(self.test_folder, stem + ".actual")
        parser = new_parser if new else old_parser
        with warnings.catch_warnings():
            # The test case `b"this is not a unicode escape because we are in a
            # bytestring: \N{AMPERSAND}"`` in strings_new.py gives a DeprecationWarning,
            # however we are actually testing the parser behavior on such bad code, so
            # we can't just "fix" the code. You would think we could use the Python
            # warning filter to ignore this specific warning, but that doesn't work --
            # furthermore, using `error::DeprecationWarning` makes the *output* of the
            # test change :O
            #
            # This was the best solution I could come up with that _both_ allows pytest
            # to error on normal deprecation warnings, but also allows this one case to
            # exist.
            if filename == "strings_new.py":
                warnings.simplefilter("ignore", DeprecationWarning)
            ast = parser(pyfile, logger)
        with open(actual, "w") as actual_file:
            AstDumper(actual_file).visit(ast)
        try:
            diff = subprocess.check_output(["git", "diff", "--patience", "--no-index", expected, actual])
        except subprocess.CalledProcessError as e:
            diff = e.output
        if diff:
            pytest.fail(diff.decode("utf-8"))

        self.check_for_stdout_errors(logger)
        self.assertEqual(self.capsys.readouterr().err, "")
        os.remove(actual)

    def check_for_stdout_errors(self, logger):
        if logger.had_errors():
            logger.reset_error_count()
            pytest.fail("Errors/warnings were logged to stdout during testing.")

def setup_tests():
    test_folder = os.path.join(os.path.dirname(__file__), "parser")
    with StdoutLogger() as logger:
        for file in os.listdir(test_folder):
            if file.endswith(".py"):
                stem = file[:-3]
                test_name = "test_" + stem
                if stem.endswith("_new"):
                    test_func = lambda self, file=file: self.compare_expected(file, logger, new=True)
                elif stem.endswith("_old"):
                    test_func = lambda self, file=file: self.compare_expected(file, logger, new=False)
                else:
                    test_func = lambda self, file=file: self.compare_parses(file, logger)
                setattr(ParserTest, test_name, test_func)

setup_tests()
del setup_tests
