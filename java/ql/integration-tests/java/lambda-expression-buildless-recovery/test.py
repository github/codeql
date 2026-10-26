def test(codeql, java, use_java_17):
    codeql.database.create(
        build_mode="none",
        source_root="."
    )