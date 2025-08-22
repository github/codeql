import os


def test(codeql, java_full):
    os.environ["CODEQL_KOTLIN_INTERNAL_EXCEPTION_WHILE_EXTRACTING_FILE"] = "B.kt"
    codeql.database.create(command="kotlinc A.kt B.kt C.kt", source_root="code")
