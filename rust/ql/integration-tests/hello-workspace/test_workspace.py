import pytest

# currently the DB-check fails on actions because of loading files multiple times and assiging multiple locations
# see https://github.com/github/codeql-team/issues/3365
@pytest.mark.ql_test("DB-CHECK", xfail="maybe")
def test_cargo(codeql, rust, manifests, check_source_archive):
    manifests.select("Cargo.toml")
    codeql.database.create()

def test_rust_project(codeql, rust, manifests, check_source_archive):
    manifests.select("rust-project.json")
    codeql.database.create()
