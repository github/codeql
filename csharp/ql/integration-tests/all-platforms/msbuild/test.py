def test(codeql, csharp):
    # force CodeQL to use MSBuild by setting `LGTM_INDEX_MSBUILD_TARGET`
    codeql.database.create(_env={"LGTM_INDEX_MSBUILD_TARGET": "Build"})
