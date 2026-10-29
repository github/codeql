import runs_on


@runs_on.windows
def test(codeql, java, cwd, subst_drive):
    drive = subst_drive(cwd / "code")
    codeql.database.create(command=["javac test1.java", "kotlinc test2.kt"], source_root=drive)
