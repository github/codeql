import os
from create_database_utils import *
from diagnostics_test_utils import *

def go_integration_test(source = "src", db = "db", runFunction = runSuccessfully):
  # Set up a GOPATH relative to this test's root directory;
  # we set os.environ instead of using extra_env because we
  # need it to be set for the call to "go clean -modcache" later
  goPath = os.path.join(os.path.abspath(os.getcwd()), ".go")
  os.environ['GOPATH'] = goPath

  try:
    run_codeql_database_create([], lang="go", source=source, db=db, runFunction=runFunction)

    check_diagnostics()
  finally:
    # Clean up the temporary GOPATH to prevent Bazel failures next
    # time the tests are run; see https://github.com/golang/go/issues/27161
    subprocess.call(["go", "clean", "-modcache"])
