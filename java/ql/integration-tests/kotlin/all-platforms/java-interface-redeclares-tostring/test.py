import commands
import pytest


@pytest.mark.kotlin1
def test(codeql, java_full):
    commands.run(["javac", "Test.java", "-d", "bin"])
    codeql.database.create(command="kotlinc -language-version 1.9 user.kt -cp bin")
