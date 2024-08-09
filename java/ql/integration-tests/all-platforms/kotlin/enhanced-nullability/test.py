def test(codeql, java_full, cwd):
    java_srcs = [str(s) for s in cwd.glob('*.java')]

    codeql.database.create(
        command=[
            f"javac {' '.join(java_srcs)} -d {cwd / 'build'}",
            "kotlinc -language-version 1.9 user.kt -cp build",
        ]
    )
