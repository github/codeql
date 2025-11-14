def test(codeql, java, actions_toolchains_file):
    codeql.database.create(_env={"LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": str(actions_toolchains_file)})
