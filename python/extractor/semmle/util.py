import sys
import codecs
import gzip
import re
import os.path
import random
import base64
import hashlib
from io import BytesIO

#Semantic version of extractor.
#Update this if any changes are made
VERSION = "7.1.2"

PY_EXTENSIONS = ".py", ".pyw"

STDLIB_PATH = os.path.dirname(os.__file__)

def get_analysis_version():
    return PYTHON_ANALYSIS_VERSION

def get_analysis_major_version():
    return PYTHON_ANALYSIS_MAJOR_VERSION

def update_analysis_version(version):
    global PYTHON_ANALYSIS_VERSION
    PYTHON_ANALYSIS_VERSION = version
    global PYTHON_ANALYSIS_MAJOR_VERSION
    PYTHON_ANALYSIS_MAJOR_VERSION = 2 if PYTHON_ANALYSIS_VERSION.startswith("2") else 3

update_analysis_version(os.environ.get("CODEQL_EXTRACTOR_PYTHON_ANALYSIS_VERSION", "3"))

#Flow graph labels:
#These should be powers of two, to allow use of bitsets.
NORMAL_EDGE = 1
FALSE_EDGE = 2
TRUE_EDGE = 4
EXCEPTIONAL_EDGE = 8
EXHAUSTED_EDGE = 16

class SemmleError(Exception):
    'Custom Error class, for reporting errors.'
    pass

#Define our own printf function to avoid Python2/3 problems.
def printf(fmt, *args):
    'Format arguments using % operator and print to sys.stdout'
    sys.stdout.write(fmt % args)

def fprintf(fout, fmt, *args):
    'Format arguments using % operator and print to file'
    fout.write(fmt % args)

def safe_string(txt):
    #Replace all characters after the first 10k
    if len(txt) > 10000:
        txt = txt[:10000] + u"..."
    return txt.replace(u'"', u'""')

def escaped_string(txt):
    return txt.replace(u'"', u'""')


if os.name == 'nt':

    MAGIC_PREFIX = u"\\\\?\\"

    def safe_path(path):
        'Returns an absolute path, safe for use on all OSes regardless of length.'
        if path.startswith(MAGIC_PREFIX):
            return path
        return MAGIC_PREFIX + os.path.abspath(path)

    _open = open

    def open(path, *args):
        assert safe_path(path) == path
        return _open(path, *args)

else:

    def safe_path(path):
        'Returns an absolute path, safe for use on all OSes regardless of length.'
        if os.path.isabs(path):
            return path
        return os.path.abspath(path)

AUTO_GEN_STRING = "/* AUTO GENERATED PART STARTS HERE */\n"

def folder_tag(name):
    return name + ';folder'

def trap_id_escape(s):
    """Escapes characters that are interpreted specially in TRAP IDs"""
    s = s.replace("&", "&amp;")
    s = s.replace("{", "&lbrace;")
    s = s.replace("}", "&rbrace;")
    s = s.replace('"', "&quot;")
    s = s.replace('@', "&commat;")
    s = s.replace('#', "&num;")
    return s

def generate_formatting_function(fmt):
    '''Generate a new function that writes its arguments with the given format.
       For example, for the format string "dd", this function will create the following function:
            def format_ss(self, name, arg0, arg1):
                self.out.write(u'%s(%s %s)\\n' % (name, str(arg0), str(arg1)))
    '''
    func_name = 'format_' + fmt
    args = ['self', 'name'] + [ 'arg%d' % i for i in range(len(fmt)) ]
    defn = 'def %s(%s):\n' % (func_name, ', '.join(args))
    values = [ _formatting_functions[f](a) for f, a in zip(fmt, args[2:])]
    format_string = "u'%s(" + ', '.join(['%s'] * len(fmt)) + ")\\n'"
    body = '    self.out.write(%s %% (%s))\n' % (format_string, ',\n'.join(['name'] + values))
    func = defn + body
    namespace = globals()
    exec (func, namespace)
    function = namespace[func_name]
    del namespace[func_name]
    return function

def _format_d(val):
    return 'repr(%s)' % val

def _format_g(val):
    return 'self.pool.get(%s, %s)' % (val, val)

def _format_n(val):
    return '''self.pool.get(%s, %s.trap_name) if hasattr(%s, 'trap_name') else self.pool.get(%s)''' % (val, val, val, val)

def _format_r(val):
    return val

def _format_u(val):
    return '''_INVALID_RE.sub(u'\uFFFD', u'"%%s"' %% safe_string(%s))''' % val

def _format_b(val):
    return '''u'"%%s"' %% safe_string(%s.decode("latin-1"))''' % val

def _format_s(val):
    return '''%s if isinstance(%s, bytes) else _INVALID_RE.sub(u'\uFFFD', u'"%%s"' %% safe_string(str(%s)))''' % (_format_b(val), val, val)

def _format_B(val):
    return '''u'"%%s"' %% escaped_string(%s.decode("latin-1"))''' % val

def _format_S(val):
    return '''%s if isinstance(%s, bytes) else _INVALID_RE.sub(u'\uFFFD', u'"%%s"' %% escaped_string(str(%s)))''' % (_format_B(val), val, val)

def _format_x(val):
    return '''(u"false", u"true")[%s]''' % val

def _format_q(val):
    return 'format_numeric_literal(%s)' % val

_formatting_functions = {
    'b' : _format_b,
    'd' : _format_d,
    'g' : _format_g,
    'n' : _format_n,
    'r' : _format_r,
    's' : _format_s,
    'u' : _format_u,
    'x' : _format_x,
    'q' : _format_q,
    'B' : _format_B,
    'S' : _format_S,
}


def format_numeric_literal(val):
    txt = repr(val)
    return u'"%s"' % txt

class Buffer(object):
    def __init__(self, out):
        self.out = out
        self.buf = []

    def write(self, content):
        self.buf.append(content)
        if len(self.buf) > 10000:
            self.flush()

    def close(self):
        self.flush()
        self.out.close()

    def flush(self):
        self.out.write(u''.join(self.buf))
        self.buf = []

class Utf8Zip(object):

    def __init__(self):
        self.raw = BytesIO()
        gout = gzip.GzipFile('', 'wb', 5, fileobj=self.raw)
        self.out = codecs.getwriter('utf-8')(gout, errors='backslashreplace')

    def write(self, data):
        self.out.write(data)

    def close(self):
        self.out.close()

    def getvalue(self):
        return self.raw.getvalue()


class TrapWriter(object):

    _format_functions = {}

    def __init__(self):
        self.zip = Utf8Zip()
        self.out = Buffer(self.zip)
        self.pool = IDPool(self.out)
        self.written_containers = {}

    def write_tuple(self, name, fmt, *args):
        '''Write tuple accepts the following format characters:
           'b' : A bytes object. Limits the resulting string to ~10k.
           'd' : An integer
           'g' : A unicode object, as a globally shared object
           'n' : A node object (any AST, flow or variable node)
           'r' : "Raw", a precomputed id or similar.
           's' : Any object to be written as a unicode string. Limits the string to ~10k.
           'u' : A unicode object, as a string
           'x' : A boolean
           'B' : Like 'b' but not limited to 10k
           'S' : Like 's' but not limited to 10k
        '''
        if fmt in self._format_functions:
            return self._format_functions[fmt](self, name, *args)
        func = generate_formatting_function(fmt)
        self._format_functions[fmt] = func
        return func(self, name, *args)

    def get_node_id(self, node):
        if hasattr(node, 'trap_name'):
            return self.pool.get(node, node.trap_name)
        else:
            return self.pool.get(node)

    def has_written(self, node):
        return node in self.pool.pool

    def get_unique_id(self):
        return self.pool.get_unique_id()

    '''Return an id that is shared across trap files,
       whenever the label is used'''
    def get_labelled_id(self, obj, label):
        return self.pool.get(obj, label)

    def write_container(self, fullpath, is_file):
        if fullpath in self.written_containers:
            return self.written_containers[fullpath]
        folder, filename = os.path.split(fullpath)
        if is_file:
            tag = get_source_file_tag(fullpath)
            self.write_tuple(u'files', 'gs', tag, fullpath)
        else:
            tag = get_folder_tag(fullpath)
            self.write_tuple(u'folders', 'gs', tag, fullpath)
        self.written_containers[fullpath] = tag
        if folder and filename:
            folder_tag = self.write_container(folder, False)
            self.write_tuple(u'containerparent' , 'gg', folder_tag, tag)
        return tag

    def write_file(self, fullpath):
        '''Writes `files` tuple plus all container tuples, up to the root.
        Returns the tag.
        Records tuples written to avoid duplication.
        '''
        return self.write_container(fullpath, True)

    def write_folder(self, fullpath):
        '''Writes `folders` tuple plus all container tuples, up to the root.
        Returns the tag.
        Records tuples written to avoid duplication.
        '''
        return self.write_container(fullpath, False)

    def get_compressed(self):
        '''Returns the gzipped compressed, utf-8 encoded contents of this trap file.
        Closes the underlying zip stream, which means that no more tuples can be added.'''
        self.out.close()
        return self.zip.getvalue()

    def write_comment(self, text):
        self.out.write(u'// %s\n' % text)

# RegEx to find invalid characters
_INVALID_RE = re.compile(u'[^\u0000-\uD7FF\uE000-\uFFFF]', re.UNICODE)

class _HashableList(object):
    'Utility class for handling lists in the IDPool'

    def __init__(self, items):
        self.items = items

    def __eq__(self, other):
        if not isinstance(other, _HashableList):
            return False
        return self.items is other.items

    def __ne__(self, other):
        if not isinstance(other, _HashableList):
            return True
        return self.items is not other.items

    def __hash__(self):
        return id(self.items)

class IDPool(object):

    def __init__(self, out, init_id = 10000):
        self.out = out
        self.pool = {}
        self.next_id = init_id

    def get_unique_id(self):
        res = u'#' + str(self.next_id)
        self.out.write(res + u' = *\n')
        self.next_id += 1
        return res

    def get(self, node, name=None):
        """Gets the ID for the given node, creating a new one if necessary.
        Inside name (if supplied), the characters &, {, }, ", @, and # will be escaped,
        as these have special meaning in TRAP IDs
        """
        #Need to special case lists as they are unhashable
        if type(node) is list:
            node = _HashableList(node)
        if node in self.pool:
            return self.pool[node]
        next_id = (u'#' +
                   str(self.next_id))
        if name is not None:
            name = str(name)
            name = u'@"%s"' % safe_string(trap_id_escape(name))
        else:
            name = u'*'
        self.out.write(u"%s = %s\n" % (next_id, name))
        self.pool[node] = next_id
        self.next_id += 1
        return next_id


def get_folder_tag(folder):
    return '/'.join(folder.split(os.path.sep)) + ';folder'


def get_source_file_tag(fullpath):
    return fullpath, sys.getfilesystemencoding() + u';sourcefile'

def makedirs(path):
    try:
        os.makedirs(path)
    except OSError:
        #If directory does not exist then error was a real one.
        if not os.path.isdir(path):
            raise

def clean_cache(subdir, suffix, verbose):
    #Remove any pre-existing cached files as they are now out of date
    if os.path.exists(subdir):
        for filename in os.listdir(subdir):
            if not filename.endswith(suffix):
                continue
            filepath = os.path.join(subdir, filename)
            try:
                if verbose:
                    print ("Deleting stale trap file: " + filepath)
                os.remove(filepath)
            except Exception as ex:
                if verbose:
                    msg = "Failed to remove stale trap file %s due to %s"
                    print (msg % (filepath, repr(ex)))
    else:
        makedirs(subdir)

if os.name == 'nt':

    def storage_path(container, path):
        ''' Returns a path in a source archive, trap-output or trap-cache.'''
        path = path.replace(":", "_")
        if os.path.isabs(path):
            path = path[1:]
        return safe_path(os.path.join(container, path))

    def isdir(path):
        if len(path) > 240:
            path = "\\\\?\\" + path
        return os.path.isdir(path)

    def islink(path):
        if len(path) > 240:
            path = "\\\\?\\" + path
        return os.path.islink(path)

    def listdir(path):
        if len(path) > 240:
            path = "\\\\?\\" + path
        return os.listdir(path)

else:

    def storage_path(container, path):
        ''' Returns a path in a source archive, trap-output or trap-cache.'''
        if os.path.isabs(path):
            path = path[1:]
        return safe_path(os.path.join(container, path))

    isdir = os.path.isdir
    islink = os.path.islink
    listdir = os.listdir


LATIN1 = codecs.lookup("latin-1")
UTF8 = codecs.lookup("utf-8")

def was_interned_ascii_bytes(txt):
    return txt is sys.intern(txt[:])

def is_a_number(txt):
    try:
        float(txt)
        return True
    except ValueError:
        return False


#Should only be set to True for debugging and testing
USE_INTOLERANT_ENCODING = False

def change_default_encoding():

    if USE_INTOLERANT_ENCODING:

        def _decode(input, errors=None):
            '''If the input is interned (program source) or a number, then it is safe to implicitly convert it.
            Otherwise it may not be, so raise an exception'''
            if not was_interned_ascii_bytes(input) and not is_a_number(input):
                f = sys._getframe(1)
                if "semmle" in f.f_code.co_filename:
                    raise SemmleError(b"Implicit decode of '%s' at %s:%d" % (input, f.f_code.co_filename, f.f_lineno))
            try:
                return UTF8.decode(input)
            except UnicodeDecodeError:
                return LATIN1.decode(input)

        def _encode(input, errors=None):
            f = sys._getframe(1)
            if "semmle" in f.f_code.co_filename:
                raise SemmleError("Implicit encode of '%s' at %s:%d" % (UTF8.encode(input), f.f_code.co_filename, f.f_lineno))
            return UTF8.encode(input, "backslashreplace")

    else:

        def _decode(input, errors=None):
            '''Convert bytes to unicode without failing.'''
            try:
                return UTF8.decode(input)
            except UnicodeDecodeError:
                return LATIN1.decode(input)

        def _encode(input, errors=None):
            '''Convert unicode to bytes without failing.'''
            return UTF8.encode(input, "backslashreplace")

    def search(name):
        if name != "safe":
            return None
        return codecs.CodecInfo(_encode, _decode, name="safe")
    codecs.register(search)
    from importlib import reload
    reload(sys)
    sys.setdefaultencoding("safe")
    del sys.setdefaultencoding

_sys_rand = random.SystemRandom()

def uuid(local_name):
    '''Return a randomised string to use as a UUID.
    Do not use the uuid module as it calls out to ldconfig,
    which is prohibited in some sandboxed environments.
    '''
    hex_string = hex(_sys_rand.randrange(1 << 256))
    #Strip leading '0x'
    return hex_string[2:] + "-" + local_name


class Extractable(object):
    '''Extractable class representing a Extractable of extraction.
    Typically a file, but may be other things like a built-in Python module.
    '''

    def __ne__(self, other):
        return not self == other

    @staticmethod
    def from_path(path):
        if os.path.isdir(path):
            return FolderExtractable(path)
        elif os.path.isfile(path):
            return FileExtractable(path)
        else:
            raise IOError("% does not exist" % path)

class PathExtractable(Extractable):

    PATTERN = 421706893

    __slots__ = [ 'path' ]

    def __init__(self, path):
        assert "<compiled code>" not in path
        self.path = path

    def __eq__(self, other):
        return isinstance(other, type(self)) and self.path == other.path

    def __hash__(self):
        return hash(self.path) ^ self.PATTERN

class FileExtractable(PathExtractable):

    PATTERN = 1903946595

    __slots__ = [ 'path' ]

    def __str__(self):
        return "file " + self.path

    def __repr__(self):
        return "FileExtractable(%r)" % self.path


class FolderExtractable(PathExtractable):

    PATTERN = 712343093

    __slots__ = [ 'path' ]

    def __str__(self):
        return "folder " + self.path

    def __repr__(self):
        return "FolderExtractable(%r)" % self.path

class BuiltinModuleExtractable(Extractable):

    __slots__ = [ 'name' ]

    def __init__(self, name):
        self.name = name

    def __str__(self):
        return "module " + self.name

    def __repr__(self):
        return "BuiltinModuleExtractable(%r)" % self.name

    def __eq__(self, other):
        return isinstance(other, BuiltinModuleExtractable) and self.name == other.name

    def __hash__(self):
        return hash(self.name) ^ 82753421

def base64digest(code):
    return base64.b64encode(hashlib.sha1(code.encode("utf8")).digest(), b"_-").decode("ascii")
