import commands


def test(codeql, java_full, cwd):
    # Compile library Kotlin file untraced. Note the library is hidden under `libsrc` so the Kotlin compiler
    # will certainly reference the jar, not the source or class file.
    commands.run(["kotlinc", *(cwd / "libsrc").glob("*.kt"), "-d", "build"])
    commands.run(
        ["jar", "cf", "extlib.jar", "-C", "build", "abcdefghij", "-C", "build", "META-INF"]
    )
    codeql.database.create(command=["kotlinc user.kt -cp extlib.jar"])
