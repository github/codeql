import os

def test(codeql, java, check_diagnostics_java):
    # mvnw has been rigged to stall for a long time by trying to fetch from a black-hole IP. We should find the timeout logic fires and buildless aborts the Maven run quickly.
    codeql.database.create(
        build_mode="none",
        _env={
            "CODEQL_EXTRACTOR_JAVA_BUILDLESS_CHILD_PROCESS_IDLE_TIMEOUT": "5",
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml"),
        },
    )
