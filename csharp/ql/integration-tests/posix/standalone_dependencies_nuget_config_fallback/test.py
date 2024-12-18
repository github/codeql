import os
import runs_on


@runs_on.posix
def test(codeql, csharp):

    # os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK"] = "true"        # Nuget feed check is enabled by default
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_TIMEOUT"] = (
        "1"  # 1ms, the GET request should fail with such short timeout
    )
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_LIMIT"] = (
        "1"  # Limit the count of checks to 1
    )

    # Making sure the reachability test succeeds when doing a fallback restore:
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT"] = "1000"
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT"] = "5"

    codeql.database.create(build_mode="none")
