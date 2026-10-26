import os


def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_COMPILER_DIAGNOSTIC_LIMIT"] = "2"
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_MESSAGE_LIMIT"] = "5"
    codeql.database.create(build_mode="none")
