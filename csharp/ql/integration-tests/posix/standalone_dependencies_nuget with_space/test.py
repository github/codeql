import os
import runs_on
import pytest


# Skipping the test on the ARM runners, as we're running into trouble with Mono and nuget.
@pytest.mark.only_if(runs_on.linux or (runs_on.macos and runs_on.x86_64))
def test(codeql, csharp):
    # making sure we're not doing any fallback restore:
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT"] = "1"
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT"] = "1"
    codeql.database.create(build_mode="none")
