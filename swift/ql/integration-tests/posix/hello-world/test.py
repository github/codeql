import pytest

import runs_on


@runs_on.posix
def test(codeql, swift):
    codeql.database.create(command="swift build")

@runs_on.posix
@pytest.mark.ql_test(None)
def test_do_not_print_env(codeql, swift, check_env_not_dumped):
    codeql.database.create(command="swift build", _env={
        "CODEQL_EXTRACTOR_SWIFT_LOG_LEVELS": "out:text:trace",
    })
