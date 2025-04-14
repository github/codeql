import pytest


@pytest.mark.ql_test("steps.ql", expected=".cargo.expected")
def test_cargo(codeql, rust, cargo, check_source_archive, rust_check_diagnostics):
    codeql.database.create()

@pytest.mark.ql_test("steps.ql", expected=".rust-project.expected")
def test_rust_project(codeql, rust, rust_project, check_source_archive, rust_check_diagnostics):
    codeql.database.create()

@pytest.mark.ql_test(None)
def test_do_not_print_env(codeql, rust, cargo, check_env_not_dumped, rust_check_diagnostics):
    codeql.database.create(_env={
        "CODEQL_EXTRACTOR_RUST_VERBOSE": "2",
    })
