import os


def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS"] = "true"
    codeql.database.create()
