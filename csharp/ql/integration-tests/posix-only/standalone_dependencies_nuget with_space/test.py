from create_database_utils import *
import os

# making sure we're not doing any fallback restore:
os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT"] = "1"
os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT"] = "1"

run_codeql_database_create([], lang="csharp", extra_args=["--build-mode=none"])
