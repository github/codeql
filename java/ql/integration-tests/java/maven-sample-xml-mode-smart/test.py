import os

def test(codeql, java):
    codeql.database.create(
        _env={
            "LGTM_INDEX_XML_MODE": "smart",
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml"),
        },
    )
