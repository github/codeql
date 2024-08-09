import os
import commands
from build_fixture import build_fixture


@build_fixture
def build():
    commands.run("kotlinc KotlinDefault.kt")
    os.environ["CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN"] = "true"
    commands.run("kotlinc KotlinDisabled.kt")
    del os.environ["CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN"]
    os.environ["CODEQL_EXTRACTOR_JAVA_AGENT_ENABLE_KOTLIN"] = "true"
    commands.run("kotlinc KotlinEnabled.kt")


def test(codeql, java_full, build):
    for var in [
        "CODEQL_EXTRACTOR_JAVA_AGENT_ENABLE_KOTLIN",
        "CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN",
    ]:
        if var in os.environ:
            del os.environ[var]
    codeql.database.create(command=build)
