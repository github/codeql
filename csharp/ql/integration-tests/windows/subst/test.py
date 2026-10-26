import runs_on


@runs_on.windows
def test(codeql, csharp, cwd, subst_drive):
    drive = subst_drive(cwd / "code")
    codeql.database.create(source_root=drive)
