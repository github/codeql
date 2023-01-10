import sys

from create_database_utils import *

# Test that a build with 5 ~1MB XML docs extracts them:
for i in range(5):
  with open("generated-%d.xml" % i, "w") as f:
    f.write("<xml>" + ("a" * 1000000) + "</xml>")

run_codeql_database_create([], lang="java")
