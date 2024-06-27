import sys

from create_database_utils import *
import shutil
import os.path
import tempfile
import platform

#The version of gradle used doesn't work on java 17
try_use_java11()

gradle_override_dir = tempfile.mkdtemp()
if platform.system() == "Windows":
  with open(os.path.join(gradle_override_dir, "gradle.bat"), "w") as f:
    f.write("@echo off\nexit /b 2\n")
else:
  gradlepath = os.path.join(gradle_override_dir, "gradle")
  with open(gradlepath, "w") as f:
    f.write("#!/bin/bash\nexit 1\n")
  os.chmod(gradlepath, 0o0755)

oldpath = os.getenv("PATH")
os.environ["PATH"] = gradle_override_dir + os.pathsep + oldpath

try:
  run_codeql_database_create([], lang="java")
finally:
  try:
    shutil.rmtree(gradle_override_dir)
  except Exception as e:
    pass
