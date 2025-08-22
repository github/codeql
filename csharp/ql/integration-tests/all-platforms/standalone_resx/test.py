import os


def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_EXTRACT_RESOURCES"] = "true"
    codeql.database.create(build_mode="none")
