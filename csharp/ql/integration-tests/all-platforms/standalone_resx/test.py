import os


def test(codeql, csharp):
    # Making sure the reachability test of `nuget.org` succeeds:
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT"] = "1000"
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT"] = "5"

    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_EXTRACT_RESOURCES"] = "true"
    codeql.database.create(build_mode="none")
