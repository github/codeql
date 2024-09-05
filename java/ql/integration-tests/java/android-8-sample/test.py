# Put Java 11 on the path so as to challenge our version selection logic: Java 11 is unsuitable for Android Gradle Plugin 8+,
# so it will be necessary to notice Java 17 available in the environment and actively select it.
def test(codeql, use_java_11, java, gradle_8_0, android_sdk):
    codeql.database.create()
