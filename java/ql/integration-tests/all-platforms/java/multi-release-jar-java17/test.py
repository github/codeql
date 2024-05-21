import sys

from create_database_utils import *
import subprocess
import os

os.mkdir("mod1obj")
os.mkdir("mod2obj")

subprocess.check_call(["javac", "mod1/module-info.java", "mod1/mod1pkg/Mod1Class.java", "-d", "mod1obj"])
subprocess.check_call(["jar", "-c", "-f", "mod1.jar", "-C", "mod1obj", "mod1pkg/Mod1Class.class", "--release", "9", "-C", "mod1obj", "module-info.class"])

run_codeql_database_create(["javac mod2/mod2pkg/User.java mod2/module-info.java -d mod2obj -p mod1.jar"], lang="java")
