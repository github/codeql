import os

def test(codeql, java):
    codeql.database.create(
        _env={
            "EXPECT_MAVEN": "apache-maven-3.9.9",
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml"),
        },
    )
