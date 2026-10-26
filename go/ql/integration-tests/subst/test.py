import runs_on


@runs_on.windows
def test(codeql, go, cwd, subst_drive):
    drive = subst_drive(cwd / "code")
    codeql.database.create(command="go build main.go", source_root=drive)
