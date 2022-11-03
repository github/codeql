from create_database_utils import *

def check_extension(directory, expected_extension):
    if platform.system() == 'Windows':
        # It's important that the path is a Unicode path on Windows, so
        # that the right system calls get used.
        directory = u'' + directory
        if not directory.startswith("\\\\?\\"):
            directory = "\\\\?\\" + os.path.abspath(directory)

    if expected_extension == '.trap':
        # We start TRAP files with a comment
        expected_start = b'//'
    elif expected_extension == '.trap.gz':
        # The GZip magic numbers
        expected_start = b'\x1f\x8b'
    else:
        raise Exception('Unknown expected extension ' + expected_extension)
    count = check_extension_worker(directory, expected_extension, expected_start)
    if count != 1:
        raise Exception('Expected 1 relevant file, but found ' + str(count) + ' in ' + directory)

def check_extension_worker(directory, expected_extension, expected_start):
    count = 0
    for f in os.listdir(directory):
        x = os.path.join(directory, f)
        if os.path.isdir(x):
            count += check_extension_worker(x, expected_extension, expected_start)
        else:
            if f.startswith('test.kt') and not f.endswith('.set'):
                if f.endswith(expected_extension):
                    with open(x, 'rb') as f_in:
                        content = f_in.read()
                    if content.startswith(expected_start):
                        count += 1
                    else:
                        raise Exception('Unexpected start to content of ' + x)
                else:
                    raise Exception('Expected test.kt TRAP file to have extension ' + expected_extension + ', but found ' + x)
    return count

run_codeql_database_create(['kotlinc test.kt'], test_db="default-db", db=None, lang="java")
check_extension('default-db/trap', '.trap.gz')
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "nOnE"
run_codeql_database_create(['kotlinc test.kt'], test_db="none-db", db=None, lang="java")
check_extension('none-db/trap', '.trap')
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "gzip"
run_codeql_database_create(['kotlinc test.kt'], test_db="gzip-db", db=None, lang="java")
check_extension('gzip-db/trap', '.trap.gz')
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "brotli"
run_codeql_database_create(['kotlinc test.kt'], test_db="brotli-db", db=None, lang="java")
check_extension('brotli-db/trap', '.trap.gz')
os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "invalidValue"
run_codeql_database_create(['kotlinc test.kt'], test_db="invalid-db", db=None, lang="java")
check_extension('invalid-db/trap', '.trap.gz')
