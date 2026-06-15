import os
import os.path
import shutil

def test(codeql, java, check_diagnostics):

    # Avoid shutil resolving mvn to the wrapper script in the test dir:
    os.environ["NoDefaultCurrentDirectoryInExePath"] = "0"
    runenv = {
        "PATH": os.path.realpath(os.path.dirname(__file__)) + os.pathsep + os.getenv("PATH"),
        "REAL_MVN_PATH": shutil.which("mvn"),
    }
    del os.environ["NoDefaultCurrentDirectoryInExePath"]
    codeql.database.create(build_mode = "none", _env = runenv)
