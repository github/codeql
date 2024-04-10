from create_database_utils import *
from diagnostics_test_utils import *
import os

os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK"] = "true"          # Enable NuGet feed check
os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_TIMEOUT"] = "1"     # 1ms, the GET request should fail with such short timeout
os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_LIMIT"] = "1"       # Limit the count of checks to 1
os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_EXCLUDED"] = "https://abc.de:8000/packages/"   # Exclude this feed from check
run_codeql_database_create([], lang="csharp", extra_args=["--build-mode=none"])
check_diagnostics()