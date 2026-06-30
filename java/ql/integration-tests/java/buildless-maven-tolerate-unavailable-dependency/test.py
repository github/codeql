import os

def test(codeql, java, check_diagnostics_java):
    codeql.database.create(
        build_mode="none",
        _env={
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml"),
        }
    )
