import os
import pytest
from ..conftest import _supports_mono_nuget


@pytest.mark.only_if(_supports_mono_nuget())
def test(codeql, csharp):
    # making sure we're not doing any fallback restore:
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT"] = "1"
    os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT"] = "1"
    codeql.database.create(build_mode="none")
