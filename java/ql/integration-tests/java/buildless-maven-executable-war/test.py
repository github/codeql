import os

def test(codeql, java, check_diagnostics_java):
    codeql.database.create(
        _env={
            "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true",
            "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true",
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml"),
        }
    )
