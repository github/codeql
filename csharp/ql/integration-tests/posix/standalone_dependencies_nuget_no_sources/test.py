import pytest
from ..conftest import _supports_mono_nuget


@pytest.mark.only_if(_supports_mono_nuget())
def test(codeql, csharp):
    codeql.database.create(source_root="proj", build_mode="none")
