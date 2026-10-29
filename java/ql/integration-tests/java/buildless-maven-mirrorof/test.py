import os
import os.path

def test(codeql, java, check_diagnostics_java, tmp_path):
    codeql.database.create(build_mode = "none",
        _env={
            "_JAVA_OPTIONS": " ".join([
                "-Duser.home=" + os.path.join(os.getcwd(), "empty-home"),
                "-Dmaven.repo.local=" + str(tmp_path / "maven-repository")
            ]),
            "LGTM_INDEX_MAVEN_SETTINGS_FILE": os.path.join(os.path.dirname(os.path.realpath(__file__)), "settings.xml")
        }
    )
