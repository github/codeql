import sys
import os.path

def check_maven_wrapper_exists(expected_version):
  if not os.path.exists(".mvn/wrapper/maven-wrapper.jar"):
    print("Maven wrapper jar file expected but not found", file = sys.stderr)
    sys.exit(1)
  with open(".mvn/wrapper/maven-wrapper.properties", "r") as f:
    content = f.read()
    if ("apache-maven-%s-" % expected_version) not in content:
      print("Expected Maven wrapper to fetch version %s, but actual properties file said:\n\n%s" % (expected_version, content), file = sys.stderr)
      sys.exit(1)
