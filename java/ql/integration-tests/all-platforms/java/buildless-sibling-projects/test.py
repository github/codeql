from create_database_utils import *
from diagnostics_test_utils import *
from buildless_test_utils import *

import tempfile
import os.path
import sys

#The version of gradle used doesn't work on java 17
try_use_java11()

# On actions, expose all usable toolchains so that we can test version-selection logic.

toolchains_dir = tempfile.mkdtemp(prefix="integration-tests-toolchains-")
toolchains_file = os.path.join(toolchains_dir, "toolchains.xml")

with open(toolchains_file, "w") as f:
  f.write('<?xml version="1.0" encoding="UTF-8"?>\n<toolchains>\n')

  for v in [8, 11, 17, 21]:
    homedir = os.getenv("JAVA_HOME_%d_X64" % v)
    if homedir is not None and homedir != "":
      f.write("""
        <toolchain>
          <type>jdk</type>
          <provides>
            <version>%d</version>
            <vendor>oracle</vendor>
          </provides>
          <configuration>
            <jdkHome>%s</jdkHome>
          </configuration>
        </toolchain>
        """ % (v, homedir))

  f.write("</toolchains>")

run_codeql_database_create([], lang="java", extra_env={"CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS": "true", "CODEQL_EXTRACTOR_JAVA_OPTION_BUILDLESS_CLASSPATH_FROM_BUILD_FILES": "true", "LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": toolchains_file})

check_diagnostics()
check_buildless_fetches()
