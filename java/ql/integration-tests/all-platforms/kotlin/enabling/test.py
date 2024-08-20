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
    os.environ.pop("CODEQL_EXTRACTOR_JAVA_AGENT_ENABLE_KOTLIN", None)
    os.environ.pop("CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN", None)
    codeql.database.create(command=build)
