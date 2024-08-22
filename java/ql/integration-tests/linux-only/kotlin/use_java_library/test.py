import runs_on


@runs_on.linux
def test(codeql, java_full, cwd):
    java_srcs = (cwd / "javasrc" / "extlib").glob("*.java")
    javac_cmd = " ".join(["javac"] + [str(s) for s in java_srcs] + ["-d", "build"])
    jar_cmd = " ".join(["jar", "-c", "-f", "extlib.jar", "-C", "build", "extlib"])
    codeql.database.create(command=[javac_cmd, jar_cmd, "kotlinc user.kt -cp extlib.jar"])
