from create_database_utils import *

# force CodeQL to use MSBuild by setting `LGTM_INDEX_MSBUILD_TARGET`
run_codeql_database_create([], test_db="default-db", db=None, lang="csharp", extra_env={ 'LGTM_INDEX_MSBUILD_TARGET': 'Build' })
