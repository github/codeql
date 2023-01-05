import sys

from create_database_utils import *

# Test that a build with 60 ~1MB XML docs extracts does not extract them, but we fall back to by-name mode instead:
for i in range(60):
  with open("generated-%d.xml" % i, "w") as f:
    f.write("<xml>" + ("a" * 1000000) + "</xml>")

run_codeql_database_create([], lang="java")
