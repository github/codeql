import os

def test(codeql, java):
    # Test that a build with 5 ~1MB XML docs extracts them:
    for i in range(5):
        with open(f"generated-{i}.xml", "w") as f:
            f.write("<xml>" + ("a" * 1000000) + "</xml>")
    codeql.database.create(
        _env={
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml")
        },
    )
