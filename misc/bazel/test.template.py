import os

os.execl("{codeql_cli_path}", "test", "run", "--check-databases", "--", *{test_sources})
