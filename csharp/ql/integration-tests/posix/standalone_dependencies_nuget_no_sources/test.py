import runs_on
import pytest
import dotnet

# Skipping the test on the ARM runners, as we're running into trouble with Mono and nuget.
@pytest.mark.only_if(
    runs_on.linux
    or (runs_on.macos and runs_on.x86_64 and not runs_on.macos_15)
)
@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    codeql.database.create(source_root="proj", build_mode="none")
