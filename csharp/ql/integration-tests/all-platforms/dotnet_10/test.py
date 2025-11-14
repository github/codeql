import os
import runs_on

def test(codeql, csharp):
    codeql.database.create()
