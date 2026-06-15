import os
import runs_on


@runs_on.posix
def test(codeql, csharp):
    # Making sure the reachability test of `nuget.org` succeeds:
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT"] = "1000"
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT"] = "5"

    codeql.database.create(build_mode="none")
