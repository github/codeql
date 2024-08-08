import runs_on
import pytest


# Skipping the test on the ARM runners, as we're running into trouble with Mono and nuget.
@pytest.mark.only_if(runs_on.linux or (runs_on.macos and runs_on.x86_64))
def test(codeql, csharp):
    codeql.database.create(build_mode="none")
