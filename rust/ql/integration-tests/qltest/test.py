import runs_on
# these tests are meant to exercise QL test running on multiple platforms
# therefore they don't rely on integration test built-in QL test running
# (which skips `qltest.{sh,cmd}`)

def test_lib(codeql, rust, cwd):
    codeql.test.run("lib", threads=1)

def test_main(codeql, rust):
    codeql.test.run("main", threads=1)

def test_failing_cargo_check(codeql, rust):
    out = codeql.test.run("failing_cargo_check", threads=1, show_extractor_output=True,
                          _assert_failure=True, _capture="stderr")
    # TODO: QL test output redirection is currently broken on windows, leaving it up for follow-up work
    if not runs_on.windows:
        assert "requested cargo check failed" in out
