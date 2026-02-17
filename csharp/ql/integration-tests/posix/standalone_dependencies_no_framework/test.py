import pytest
import os
from ..conftest import _supports_mono_nuget


@pytest.mark.only_if(_supports_mono_nuget())
def test(codeql, csharp):
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_DOTNET_FRAMEWORK_REFERENCES"] = (
        "/non-existent-path"
    )
    codeql.database.create(build_mode="none")
