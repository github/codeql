def test_cargo(codeql, rust, manifests, check_source_archive):
    manifests.select("Cargo.toml")
    codeql.database.create()

def test_rust_project(codeql, rust, manifests, check_source_archive):
    manifests.select("rust-project.json")
    codeql.database.create()
