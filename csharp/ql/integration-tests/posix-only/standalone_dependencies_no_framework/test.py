from create_database_utils import *
import os

os.environ["CODEQL_EXTRACTOR_CSHARP_BUILDLESS_DOTNET_FRAMEWORK_REFERENCES"] = "/non-existent-path"
run_codeql_database_create([], lang="csharp", extra_args=["--build-mode=none"])
