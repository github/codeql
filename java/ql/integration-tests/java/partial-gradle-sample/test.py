# The version of gradle used doesn't work on java 17


def test(codeql, use_java_11, java):
    codeql.database.create()
