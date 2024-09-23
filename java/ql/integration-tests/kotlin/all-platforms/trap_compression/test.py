import runs_on
import os


def check_extensions(directory, counts):
    if runs_on.windows:
        if not directory.startswith("\\\\?\\"):
            directory = "\\\\?\\" + os.path.abspath(directory)

    check_extensions_worker(counts, directory)
    check_counts("non-compressed", counts.expected_none, counts.count_none)
    check_counts("gzipped", counts.expected_gzip, counts.count_gzip)


def check_counts(name, expected, count):
    if expected == -1:
        assert count > 10, "Expected lots of " + name + " files, but got " + str(count)
    else:
        assert expected == count, (
            "Expected " + str(expected) + " " + name + " files, but got " + str(count)
        )


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
        elif f.endswith(".trap"):
            counts.count_none += 1
            # We start TRAP files with a comment
            assert startsWith(x, b"//"), "TRAP file that doesn't start with a comment: " + f
        elif f.endswith(".trap.gz"):
            counts.count_gzip += 1
            # The GZip magic numbers
            assert startsWith(x, b"\x1f\x8b"), (
                "GZipped TRAP file that doesn't start with GZip magic numbers: " + f
            )


def startsWith(f, b):
    with open(f, "rb") as f_in:
        content = f_in.read()
    return content.startswith(b)


# In the counts, we expect lots of files of the compression type chosen
# (so expected count is -1), but the diagnostic TRAP files will always
# be uncompressed (so count_none is always 1 or -1) and the
# sourceLocationPrefix TRAP file is always gzipped (so count_gzip is
# always 1 or -1).


def test_default(codeql, java_full):
    codeql.database.create(command="kotlinc test.kt")
    check_extensions("test-db/trap", Counts(1, -1))


def test_none(codeql, java_full):
    os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "nOnE"
    codeql.database.create(command="kotlinc test.kt")
    check_extensions("test-db/trap", Counts(-1, 1))


def test_gzip(codeql, java_full):
    os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "gzip"
    codeql.database.create(command="kotlinc test.kt")
    check_extensions("test-db/trap", Counts(1, -1))


def test_brotli(codeql, java_full):
    os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "brotli"
    codeql.database.create(command="kotlinc test.kt")
    check_extensions("test-db/trap", Counts(1, -1))


def test_invalid(codeql, java_full):
    os.environ["CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"] = "invalidValue"
    codeql.database.create(command="kotlinc test.kt")
    check_extensions("test-db/trap", Counts(1, -1))
