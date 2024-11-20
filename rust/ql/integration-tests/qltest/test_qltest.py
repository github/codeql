import runs_on
import pytest

# these tests are meant to exercise QL test running on multiple platforms
# therefore they don't rely on integration test built-in QL test running
# (which skips `qltest.{sh,cmd}`)

@pytest.fixture(autouse=True)
def default_options(codeql):
    codeql.flags.update(
        threads = 1,
        show_extractor_output = True,
        check_databases = False,
        learn = True,
    )

@pytest.mark.parametrize("dir", ["lib", "main", "dependencies"])
def test(codeql, rust, expected_files, dir):
    expected_files.add(f"{dir}/functions.expected", expected=".nested.expected")
    codeql.test.run(dir)

def test_failing_cargo_check(codeql, rust):
    out = codeql.test.run("failing_cargo_check", _assert_failure=True, _capture="stderr")
    # TODO: QL test output redirection is currently broken on windows, leaving it up for follow-up work
    if not runs_on.windows:
        assert "requested cargo check failed" in out
