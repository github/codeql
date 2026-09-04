import os

def test(codeql, java):
    codeql.database.create(
        build_mode="autobuild",
        _env={
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml"),
        },
    )
