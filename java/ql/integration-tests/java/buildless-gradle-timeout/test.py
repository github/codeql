def test(codeql, java):
    # gradlew has been rigged to stall for a long time by trying to fetch from a black-hole IP.
    # We should find the timeout logic fires and buildless aborts the Gradle run quickly.
    codeql.database.create(
        build_mode="none",
        _env={"CODEQL_EXTRACTOR_JAVA_BUILDLESS_CHILD_PROCESS_IDLE_TIMEOUT": "5"},
    )
