import pytest
import runs_on


# Skipping the test on macos-15, as we're running into trouble.
@pytest.mark.only_if(not runs_on.macos_15)
def test(codeql, csharp):
    codeql.database.create(_assert_failure=True)
