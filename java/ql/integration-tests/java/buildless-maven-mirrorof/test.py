import os
import os.path

def test(codeql, java):
    codeql.database.create(build_mode = "none",
        _env={
            "_JAVA_OPTIONS": "-Duser.home=" + os.path.join(os.getcwd(), "empty-home"),
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml")
        }
    )
