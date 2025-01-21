import pytest


@pytest.mark.ql_test("steps.ql", expected=".cargo.expected")
@pytest.mark.ql_test("summary.qlref", expected=".cargo.expected")
def test_cargo(codeql, rust, cargo, check_source_archive, rust_check_diagnostics):
    rust_check_diagnostics.expected_suffix = ".cargo.expected"
    codeql.database.create()

@pytest.mark.ql_test("steps.ql", expected=".rust-project.expected")
@pytest.mark.ql_test("summary.qlref", expected=".rust-project.expected")
def test_rust_project(codeql, rust, rust_project, check_source_archive, rust_check_diagnostics):
    rust_check_diagnostics.expected_suffix = ".rust-project.expected"
    codeql.database.create()
