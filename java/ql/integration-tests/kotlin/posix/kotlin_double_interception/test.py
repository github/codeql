from build_fixture import build_fixture
import sys
import commands
import os
import pathlib
import re
import runs_on


def say(s):
    print(s)
    sys.stdout.flush()


@build_fixture
def build():
    say("Doing normal compilation")

    # This is a normal intercepted compilation
    commands.run("kotlinc normal.kt")

    say("Identifying extractor jar")
    # Find the extractor jar that is being used
    trapDir = pathlib.Path(os.environ["CODEQL_EXTRACTOR_JAVA_TRAP_DIR"])

    invocationTrapDir = trapDir / "invocations"
    invocationTraps = list(invocationTrapDir.iterdir())
    assert len(invocationTraps) == 1, "Expected to find 1 invocation TRAP, but found " + str(
        invocationTraps
    )
    invocationTrap = os.path.join(invocationTrapDir, invocationTraps[0])
    with open(invocationTrap, "r") as f:
        content = f.read()
        m = re.search("^// Using extractor: (.*)$", content, flags=re.MULTILINE)
        extractorJar = m.group(1)

    def getManualFlags(invocationTrapName):
        return [
            f"-Xplugin={extractorJar}",
            "-P",
            f"plugin:kotlin-extractor:invocationTrapFile={trapDir / "invocations" / invocationTrapName}.trap",
        ]

    # This is both normally intercepted, and it has the extractor flags manually added
    say("Doing double-interception compilation")
    commands.run(["kotlinc", "doubleIntercepted.kt"] + getManualFlags("doubleIntercepted"))

    os.environ["CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN"] = "true"
    # We don't see this compilation at all
    say("Doing unseen compilation")
    commands.run("kotlinc notSeen.kt")
    # This is extracted as it has the extractor flags manually added
    say("Doing manual compilation")
    commands.run(["kotlinc", "manual.kt"] + getManualFlags("manual"))


@runs_on.posix
def test(codeql, java_full, build):
    codeql.database.create(command=build, source_root="code")
