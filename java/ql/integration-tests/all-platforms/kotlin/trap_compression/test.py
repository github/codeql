from create_database_utils import *

def check_extensions(directory, counts):
    if platform.system() == 'Windows':
        # It's important that the path is a Unicode path on Windows, so
        # that the right system calls get used.
        directory = u'' + directory
        if not directory.startswith("\\\\?\\"):
            directory = "\\\\?\\" + os.path.abspath(directory)

    check_extensions_worker(counts, directory)
    check_counts('non-compressed', counts.expected_none, counts.count_none)
    check_counts('gzipped', counts.expected_gzip, counts.count_gzip)

def check_counts(name, expected, count):
    if expected == -1:
        if count < 10:
            raise Exception('Expected lots of ' + name + ' files, but got ' + str(count))
    elif expected != count:
        raise Exception('Expected ' + str(expected) + ' ' + name + ' files, but got ' + str(count))

class Counts:
    def __init__(self, expected_none, expected_gzip):
        self.expected_none = expected_none
        self.expected_gzip = expected_gzip
        self.count_none = 0
        self.count_gzip = 0

def check_extensions_worker(counts, directory):
    for f in os.listdir(directory):
        x = os.path.join(directory, f)
        if os.path.isdir(x):
            check_extensions_worker(counts, x)
        elif f.endswith('.trap'):
            counts.count_none += 1
            if not startsWith(x, b'//'): # We start TRAP files with a comment
                raise Exception("TRAP file that doesn't start with a comment: " + f)
        elif f.endswith('.trap.gz'):
            counts.count_gzip += 1
            if not startsWith(x, b'\x1f\x8b'): # The GZip magic numbers
                raise Exception("GZipped TRAP file that doesn't start with GZip magic numbers: " + f)

def startsWith(f, b):
    with open(f, 'rb') as f_in:
        content = f_in.read()
    return content.startswith(b)

# In the counts, we expect lots of files of the compression type chosen
# (so expected count is -1), but the diagnostic TRAP files will always
# be uncompressed (so count_none is always 1 or -1) and the
# sourceLocationPrefix TRAP file is always gzipped (so count_gzip is
# always 1 or -1).
run_codeql_database_create(['kotlinc test.kt'], test_db="default-db", db=None, lang="java")
check_extensions('default-db/trap', Counts(1, -1))
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "nOnE"
run_codeql_database_create(['kotlinc test.kt'], test_db="none-db", db=None, lang="java")
check_extensions('none-db/trap', Counts(-1, 1))
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "gzip"
run_codeql_database_create(['kotlinc test.kt'], test_db="gzip-db", db=None, lang="java")
check_extensions('gzip-db/trap', Counts(1, -1))
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "brotli"
run_codeql_database_create(['kotlinc test.kt'], test_db="brotli-db", db=None, lang="java")
check_extensions('brotli-db/trap', Counts(1, -1))
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "invalidValue"
run_codeql_database_create(['kotlinc test.kt'], test_db="invalid-db", db=None, lang="java")
check_extensions('invalid-db/trap', Counts(1, -1))
