from create_database_utils import *
from diagnostics_test_utils import *

# force CodeQL to use MSBuild by setting `LGTM_INDEX_MSBUILD_TARGET`
run_codeql_database_create([], db=None, lang="csharp", extra_env={ 'LGTM_INDEX_MSBUILD_TARGET': 'Build' })
check_diagnostics()
