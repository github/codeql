def test(codeql, use_java_11, java, android_sdk, actions_toolchains_file):
    codeql.database.create(_env={"LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": str(actions_toolchains_file)})
