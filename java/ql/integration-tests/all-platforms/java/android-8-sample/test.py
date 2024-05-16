import sys

from create_database_utils import *

# Put Java 11 on the path so as to challenge our version selection logic: Java 11 is unsuitable for Android Gradle Plugin 8+,
# so it will be necessary to notice Java 17 available in the environment and actively select it.

try_use_java11()

run_codeql_database_create([], lang="java")
