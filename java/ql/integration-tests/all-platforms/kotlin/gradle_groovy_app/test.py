import platform
from create_database_utils import *

gradle_cmd = "gradlew.bat" if platform.system() == "Windows" else "./gradlew"

run_codeql_database_create(
    ["%s build --no-daemon --no-build-cache" % gradle_cmd], lang="java")
