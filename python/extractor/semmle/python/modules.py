'''MODULE_TYPES: mapping from type-code returned by
imp.find_module to Module subclass'''

import semmle.python.parser.tokenizer
import semmle.python.parser.tsg_parser
import re
import os
from blib2to3.pgen2 import tokenize
import codecs

from semmle.python.passes.labeller import Labeller
from semmle.util import base64digest
from semmle.profiling import timers

__all__ = [ 'PythonSourceModule' ]

class PythonSourceModule(object):

    kind = None

    def __init__(self, name, path, logger, bytes_source = None):
        assert isinstance(path, str), path
        self.name = name # May be None
        self.path = path
        if bytes_source is None:
            with timers["load"]:
                with open(self.path, 'rb') as src:
                    bytes_source = src.read()
        if BIN_PYTHON.match(bytes_source):
            self.kind = "Script"
        self._ast = None
        self._py_ast = None
        self._lines = None
        self._line_types = None
        self._comments = None
        self._tokens = None
        self.logger = logger
        with timers["decode"]:
            self.encoding, self.bytes_source  = semmle.python.parser.tokenizer.encoding_from_source(bytes_source)
        if self.encoding != 'utf-8':
            logger.debug("File '%s' has encoding %s.", path, self.encoding)
        try:
            self._source = self.bytes_source.decode(self.encoding)
            self._illegal_encoding = False
        except Exception as ex:
            self.logger.warning("%s has encoding '%s'", path, self.encoding)
            #Set source to a latin-1 decoding of source string (which cannot fail).
            #Attempting to get the AST will raise a syntax error as expected.
            self._source = self.bytes_source.decode("latin-1")
            self._illegal_encoding = str(ex)
        self._source = normalize_line_endings(self._source)
        #Strip BOM
        if self._source.startswith(u'\ufeff'):
            self._source = self._source[1:]
        self._secure_hash = base64digest(self._source)
        assert isinstance(self._source, str)

    @property
    def source(self):
        return self._source

    @property
    def lines(self):
        if self._lines is None:
            def genline():
                src = self._source
                #Handle non-linux line endings
                src = src.replace("\r\n", "\n").replace("\r", "\n")
                length = len(src)
                start = 0
                while True:
                    end = src.find(u'\n', start)
                    if end < 0:
                        if start < length:
                            yield src[start:]
                        return
                    yield src[start:end+1]
                    start = end+1
            self._lines = list(genline())
        return self._lines

    @property
    def tokens(self):
        if self._tokens is None:
            with timers["tokenize"]:
                tokenizer = semmle.python.parser.tokenizer.Tokenizer(self._source)
                self._tokens = list(tokenizer.tokens())
        return self._tokens

    @property
    def ast(self):
        # The ast will be modified by the labeller, so we cannot share it with the py_ast property.
        # However, we expect py_ast to be accessed and used before ast, so we avoid reparsing in that case.
        if self._ast is None:
            if self._illegal_encoding:
                message = self._illegal_encoding
                error = SyntaxError(message)
                error.filename = self.path
                error.lineno, error.offset = offending_byte_position(message, self.bytes_source)
                raise error
            self._ast = self.py_ast
            self._ast.trap_name = self.trap_name
            self._py_ast = None
            with timers["label"]:
                Labeller().apply(self)
        return self._ast

    @property
    def old_py_ast(self):
        # The py_ast is the raw ast from the Python parser.
        if self._py_ast is None:
            with timers["old_py_ast"]:
                self.logger.debug("Trying old parser on %s", self.path)
                self._py_ast = semmle.python.parser.parse(self.tokens, self.logger)
                self.logger.debug("Old parser successful on %s", self.path)
        else:
            self.logger.debug("Found (during old_py_ast) parse tree for %s in cache", self.path)
        return self._py_ast

    @property
    def py_ast(self):
        try:
            # If the `CODEQL_PYTHON_DISABLE_OLD_PARSER` flag is present, we do not try to use the
            # old parser, and instead jump straight to the exception handler.
            if os.environ.get("CODEQL_PYTHON_DISABLE_OLD_PARSER"):
                self.logger.debug("Old parser disabled, skipping old parse attempt for %s", self.path)
                raise Exception("Skipping old parser")
            # Otherwise, we first try to parse the source with the old Python parser.
            self._py_ast = self.old_py_ast
            return self._py_ast
        except Exception as ex:
            # If that fails, try to parse the source with the new Python parser (unless it has been
            # explicitly disabled).
            #
            # Like PYTHONUNBUFFERED for Python, we treat any non-empty string as meaning the
            # flag is enabled.
            # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUNBUFFERED
            if os.environ.get("CODEQL_PYTHON_DISABLE_TSG_PARSER"):
                if isinstance(ex, SyntaxError):
                    raise ex
                else:
                    raise SyntaxError("Exception %s while parsing %s" % (ex, self.path))
            else:
                try:
                    with timers["tsg_py_ast"]:
                        if self._py_ast is None:
                            self.logger.debug("Trying tsg-python on %s", self.path)
                            self._py_ast = semmle.python.parser.tsg_parser.parse(self.path, self.logger)
                            self.logger.debug("tsg-python successful on %s", self.path)
                        else:
                            self.logger.debug("Found (during py_ast) parse tree for %s in cache", self.path)
                    return self._py_ast
                except SyntaxError as ex:
                    raise ex
                except Exception as ex:
                    raise SyntaxError("Exception %s in tsg-python while parsing %s" % (ex, self.path))


    @property
    def trap_name(self):
        return type(self).__name__ + ':' + self.path + ":" + self._secure_hash

    def get_hash_key(self, token):
        return base64digest(self.path + u":" + self._secure_hash + token)

    def get_encoding(self):
        'Returns encoding of source'
        return self.encoding

    @property
    def comments(self):
        ''' Returns an iterable of comments in the form:
        test, start, end where start and end are line. column
        pairs'''
        if self._comments is None:
            self._lexical()
        return self._comments

    def close(self):
        self.bytes_source = None
        self._source = None
        self._ast = None
        self._line_types = None
        self._comments = None
        self._lines = None

    def _lexical(self):
        self._comments = []
        for kind, text, start, end in self.tokens:
            if kind == tokenize.COMMENT:
                self._comments.append((text, start, end))

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.close()


NEWLINE = b'\n'
OFFENDING_BYTE_RE = re.compile(r"decode byte \w+ in position (\d+):")

def offending_byte_position(message, string):
    m = OFFENDING_BYTE_RE.search(message)
    if m is None:
        return (0,0)
    badposition = int(m.group(1))
    prefix = string[:badposition]
    line = prefix.count(NEWLINE) + 1
    column = badposition - prefix.rfind(NEWLINE) - 1
    return (line, column)


BIN_PYTHON = re.compile(b'#! *(/usr|/bin|/local)*/?(env)? *python')

def is_script(path):
    '''Is the file at `path` a script? (does it start with #!... python)'''
    try:
        with open(path, "rb") as contents:
            start = contents.read(100)
        return bool(BIN_PYTHON.match(start))
    except Exception:
        return False

def normalize_line_endings(src):
    #Our tokenizer expects single character `\n`, `\r` or `\f` as line endings.
    src = src.replace(u'\r\n', u'\n')
    #Our parser expects that there are no unterminated lines.
    if src and src[-1] != u'\n':
        return src + u'\n'
    return src
