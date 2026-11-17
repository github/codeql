def test(codeql, python, cwd, check_diagnostics):
    check_diagnostics.skip_source_ids = ["py/extractor/parser-statistics"]
    check_diagnostics.skip = [
        "attributes.args",
        "attributes.traceback",
        "attributes.extractor_version",
        "attributes.python_analysis_version",
        "attributes.python_runtime_version",
    ]
    # Creates a test file that will cause a RecursionError when run with the Python extractor.
    (cwd / "repo_dir" / "recursion_error.py").write_text(
        "print({})\n".format("+".join(["1"] * 1000))
    )
    codeql.database.create(source_root="repo_dir")
