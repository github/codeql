def test_macro_expansion(codeql, rust, check_source_archive, rust_check_diagnostics):
    codeql.database.create()
