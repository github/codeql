import pathlib
import pytest


@pytest.mark.kotlin1
def test(codeql, java_full):
    java_srcs = " ".join([str(s) for s in pathlib.Path().glob("*.java")])
    codeql.database.create(
        command=[
            f"javac {java_srcs} -d build",
            "kotlinc -language-version 1.9 user.kt -cp build",
        ]
    )
