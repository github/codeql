import os

import pytest
import runs_on


# NB: on our Linux CI infrastructure, `python` is aliased to `python3`.
@runs_on.posix
@pytest.mark.ql_test(None)
def test_without_python3(codeql, python, cwd):
    # Test 1: Only Python 2 is available. Should fail.
    codeql.database.create(
        source_root="repo_dir",
        _env={"PATH": str(cwd / "without-python3") + os.pathsep + os.environ["PATH"]},
        _assert_failure=True,
    )


@runs_on.posix
@pytest.mark.ql_test(expected=".without-python2.expected")
def test_without_python2(codeql, python, cwd):
    # Test 2: Only Python 3 is available. Should extract using Python 3 and use the
    # Python 3 standard library.
    codeql.database.create(
        source_root="repo_dir",
        _env={"PATH": str(cwd / "without-python2") + os.pathsep + os.environ["PATH"]},
    )


@runs_on.posix
@pytest.mark.ql_test(expected=".python2-using-python3.expected")
def test_python2_using_python3(codeql, python):
    # Test 3: Python 2 and 3 are both available. Should extract using Python 3, but
    # use the Python 2 standard library.
    codeql.database.create(source_root="repo_dir")
