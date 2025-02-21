import os
import os.path
import shutil

def test(codeql, java, check_diagnostics):
    runenv = {
        "PATH": os.path.realpath(os.path.dirname(__file__)) + os.pathsep + os.getenv("PATH"),
        "REAL_MVN_PATH": shutil.which("mvn"),
    }
    codeql.database.create(build_mode = "none", _env = runenv)
