import pytest


@pytest.mark.ql_test("steps.ql", expected=".cargo.expected")
def test_cargo(codeql, rust, manifests, check_source_archive, rust_check_diagnostics):
    manifests.select("Cargo.toml")
    codeql.database.create()

@pytest.mark.ql_test("steps.ql", expected=".rust-project.expected")
def test_rust_project(codeql, rust, manifests, check_source_archive, rust_check_diagnostics):
    manifests.select("rust-project.json")
    codeql.database.create()
