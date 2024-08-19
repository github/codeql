import runs_on
import pytest
import os


# Skipping the test on the ARM runners, as we're running into trouble with Mono and nuget.
@pytest.mark.only_if(runs_on.linux or (runs_on.macos and runs_on.x86_64))
def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_DOTNET_FRAMEWORK_REFERENCES"] = (
        "/non-existent-path"
    )
    codeql.database.create(build_mode="none")
