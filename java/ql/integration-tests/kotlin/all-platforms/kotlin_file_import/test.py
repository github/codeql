import commands
import pathlib


def test(codeql, java_full):
    # Compile library Kotlin file untraced. Note the library is hidden under `libsrc` so the Kotlin compiler
    # will certainly reference the jar, not the source or class file.
    commands.run(["kotlinc", *pathlib.Path("libsrc").glob("*.kt"), "-d", "build"])
    commands.run(
        ["jar", "cf", "extlib.jar", "-C", "build", "abcdefghij", "-C", "build", "META-INF"]
    )
    codeql.database.create(command=["kotlinc user.kt -cp extlib.jar"])
