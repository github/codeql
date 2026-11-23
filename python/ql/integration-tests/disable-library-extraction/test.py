def test(codeql, python, cwd):
    # In 2.16.0 we will not extract libraries by default, so there is no difference in what
    # is extracted by setting this environment variable.. We should remove this test when
    # 2.17.0 is released.
    codeql.database.create(
        "normal-db",
        source_root="repo_dir",
        _env={"CODEQL_EXTRACTOR_PYTHON_DISABLE_LIBRARY_EXTRACTION": ""},
    )
    codeql.database.create(
        "no-lib-extraction-db",
        source_root="repo_dir",
        _env={"CODEQL_EXTRACTOR_PYTHON_DISABLE_LIBRARY_EXTRACTION": "1"},
    )

    extracted_normal = sum(
        path.is_file() for path in (cwd / "normal-db" / "src").rglob("*")
    )
    extracted_no_lib_extraction = sum(
        path.is_file() for path in (cwd / "no-lib-extraction-db" / "src").rglob("*")
    )
    assert extracted_no_lib_extraction >= extracted_normal
