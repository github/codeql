import os

def test(codeql, go):
    codeql.database.create(source_root="src", command="go build")
