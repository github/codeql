import os
import os.path

def test(codeql, java):
    codeql.database.create(build_mode = "none",
        _env={
            "_JAVA_OPTIONS": "-Duser.home=" + os.path.join(os.getcwd(), "home-dir-with-maven-settings")
        }
    )
