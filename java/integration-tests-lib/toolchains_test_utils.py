import os.path
import sys
import tempfile

def actions_expose_all_toolchains():

  # On actions, expose all usable toolchains so that we can test version-selection logic.

  toolchains_dir = tempfile.mkdtemp(prefix="integration-tests-toolchains-")
  toolchains_file = os.path.join(toolchains_dir, "toolchains.xml")

  def none_or_blank(s):
    return s is None or s == ""

  with open(toolchains_file, "w") as f:
    f.write('<?xml version="1.0" encoding="UTF-8"?>\n<toolchains>\n')

    for v in [8, 11, 17, 21]:
      homedir = os.getenv("JAVA_HOME_%d_X64" % v)
      if none_or_blank(homedir):
        homedir = os.getenv("JAVA_HOME_%d_arm64" % v)
      if none_or_blank(homedir) and v == 8 and not none_or_blank(os.getenv("JAVA_HOME_11_arm64")):
        print("Mocking a toolchain entry using Java 11 install as a fake Java 8 entry, so this test behaves the same on x64 and arm64 runners", file = sys.stderr)
        homedir = os.getenv("JAVA_HOME_11_arm64")
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

  return toolchains_file

